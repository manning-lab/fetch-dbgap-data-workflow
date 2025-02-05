workflow fetch_dbgap {

	String download_request_num
	String downloader
	String token_string
	String ASPERA_SCP_PASS
	File key
	Int? disk
	
	call download {
		input:
			download_request_num = download_request_num,
			downloader = downloader,
			token_string = token_string,
			ASPERA_SCP_PASS = ASPERA_SCP_PASS,
			disk = disk
	}
	
	call decrypt {
		input:
			encrypted_files = download.encrypted_files,
			key = key,
			disk = disk
	}

	output {
		Array[File] decrypted_files = decrypt.decrypted_files
	}
}

task download {

	String download_request_num
	String downloader
	String token_string
	String ASPERA_SCP_PASS
	Int? disk

	command <<<
		export ASPERA_SCP_PASS="${ASPERA_SCP_PASS}" && /home/ubuntu/.aspera/connect/bin/ascp \
			-QTr -l 300M -k 1 \
			-i /home/aspera/.aspera/cli/etc/aspera_tokenauth_id_rsa \
			-W ${token_string} dbtest@gap-upload.ncbi.nlm.nih.gov:data/instant/${downloader}/${download_request_num} \
			. \
			&& find ${download_request_num} -mindepth 2 -type f -exec mv -i '{}' ${download_request_num} ';'
	>>>

	runtime {
		docker: "manninglab/fetch-dbgap-data-workflow:v3"
		disks: "local-disk " + select_first([disk,"100"]) + " HDD"
	}

	output {
		Array[File] encrypted_files = glob("${download_request_num}/*")
	}
}

task decrypt {

	Array[File] encrypted_files
	File key
	Int? disk

	command <<<
		mkdir data_dir \
			&& mv -t data_dir "${sep='" "' encrypted_files}" \
			&& /home/ubuntu/sratoolkit.3.2.0-ubuntu64/bin/vdb-decrypt --ngc ${key} data_dir
	>>>

	runtime {
		docker: "manninglab/fetch-dbgap-data-workflow:v3"
		disks: "local-disk " + select_first([disk,"100"]) + " HDD"
	}

	output {
		Array[File] decrypted_files = glob("data_dir/*")
	}
}
