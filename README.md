Workflow for downloading datasets from the dbGaP Exchange Areas (we use this for our TOPMed projects) and decrypting using the SRA toolkit.  

Updated Aspera Connect to version 4.2.13.820. Updated SRAtoolkit to 3.2.0. Updated commands to match the current requirements from dbGAP, where the ascp command is: `%ASPERA_CONNECT_DIR%\bin\ascp" -QTr -l 300M -k 1 -i "%ASPERA_CONNECT_DIR%\etc\aspera_tokenauth_id_rsa" -W XXXX dbtest@gap-upload.ncbi.nlm.nih.gov:data/instant/USER/REQUESTNUMBER .` and the `ASPERA_SCP_PASS` variable is set.

These workflows should be run within an private environment.

Required inputs:
* download_request_num: dbGaP download request ID (5-digit number)
* downloader: eRA commons ID with downloader privileges for the associated dbGaP project
* token_string: data transfer token string (long alphanumeric string; find this in -W argument of the manual command provided in the specific Download page)
* key: repository key for the overall dbGaP project (necessary for the decryption step)
* 
