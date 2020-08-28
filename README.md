Workflow for downloading datasets from dbGaP and decrypting using the SRA toolkit.  

Required inputs:
* download_request_num: dbGaP download request ID (5-digit number)
* downloader: eRA commons ID with downloader privileges for the associated dbGaP project
* token_string: data transfer token string (long alphanumeric string; find this in -W argument of the manual command provided in the specific Download page)
* key: repository key for the overall dbGaP project (necessary for the decryption step)
