workflow fetch_dbgap {

	File? kart_file
	String? download_request_num
	String? downloader
	String? token_string
	File? key_file
	Int? disk
	
  if (defined(kart_file)) {
	call download_sra {
		input:
			kart_file = kart_file,
			key_file = key_file,
			disk = disk
	}
	}
	
	if (defined(download_request_num)) {
	call download_aspera {
		input:
			download_request_num = download_request_num,
			downloader = downloader,
			token_string = token_string,
			disk = disk
	}
	}

	Array[File]? encrypted_files = if (defined(kart_file)) then download_sra.encrypted_files else download_aspera.encrypted_files
	
	call decrypt {
		input:
			encrypted_files = encrypted_files,
			key_file = key_file,
			disk = disk
	}

	output {
		Array[File] decrypted_files = decrypt.decrypted_files
	}
}


task download_sra {

  File? kart_file
  File? key_file
	Int? disk

	command <<<
		mkdir data_dir \
			&& cd data_dir \
			&& prefetch --ngc ${key_file} ${kart_file} \
	>>>

	runtime {
		docker: "quay.io/kwesterman/fetch-dbgap-data-workflow:dev"
		disks: "local-disk " + select_first([disk,"100"]) + " HDD"
	}

	output {
		Array[File] encrypted_files = glob("/data_dir/*")
	}
}


task download_aspera {

	String? download_request_num
	String? downloader
	String? token_string
	Int? disk

	command <<<
		ascp \
			-QTr -l 300M -k 1 \
			-i /home/aspera/.aspera/cli/etc/asperaweb_id_dsa.openssh \
			-W ${token_string} dbtest@gap-upload.ncbi.nlm.nih.gov:data/instant/${downloader}/${download_request_num} \
			. \
			&& find ${download_request_num} -mindepth 2 -type f -exec mv -i '{}' ${download_request_num} ';'
	>>>

	runtime {
		docker: "quay.io/kwesterman/fetch-dbgap-data-workflow:dev"
		disks: "local-disk " + select_first([disk,"100"]) + " HDD"
	}

	output {
		Array[File] encrypted_files = glob("${download_request_num}/*")
	}
}


task decrypt {

	Array[File] encrypted_files
	File key_file
	Int? disk

	command <<<
		mkdir data_dir \
			&& mv -t data_dir "${sep='" "' encrypted_files}" \
			&& vdb-decrypt --ngc ${key_file} data_dir
	>>>

	runtime {
		docker: "quay.io/kwesterman/fetch-dbgap-data-workflow:dev"
		disks: "local-disk " + select_first([disk,"100"]) + " HDD"
	}

	output {
		Array[File] decrypted_files = glob("data_dir/*")
	}
}
