workflow fetch_dbgap {

	String download_request_num
	String downloader
	String token_string
	File key
	
	call download {
		input:
			download_request_num = download_request_num,
			downloader = downloader,
			token_string = token_string
	}
	
	call decrypt {
		input:
			encrypted_dir = download.encrypted_dir,
			key = key
	}

	output {
		Array[File] data_dir = decrypt.decrypted_files
	}
}

task download {

	String download_request_num
	String downloader
	String token_string

	command {
		ascp \
			-QTr -l 300M -k 1 \
			-i /home/aspera/.aspera/cli/etc/asperaweb_id_dsa.openssh \
			-W ${token_string} dbtest@gap-upload.ncbi.nlm.nih.gov:data/instant/${downloader}/${download_request_num} \
			.
	}

	runtime {
		docker: "quay.io/kwesterman/fetch-dbgap-data-workflow"
	}

	output {
		File encrypted_dir = download_request_num
	}
}

task decrypt {

	File encrypted_dir
	File key

	command <<<
			cp -r ${encrypted_dir} data_dir \
				&& vdb-decrypt --ngc ${key} data_dir && \
				find data_dir -mindepth 2 -type f -exec mv -i '{}' data_dir ';'
	>>>

	runtime {
		docker: "quay.io/kwesterman/fetch-dbgap-data-workflow"
	}

	output {
		Array[File] decrypted_files = glob("data_dir/*")
	}
}
