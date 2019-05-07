deploy:
	zip -r -q temp/get_s3_contents.zip lambda/GetS3Contents && \
	zip -r -q temp/get_signed_url.zip lambda/GetSignedUrl && \
	cd terraform && \
	terraform apply && \
	cd .. && \
	rm temp/get_s3_contents.zip &&\
	rm temp/get_signed_url.zip

destroy:
	zip -r -q temp/get_s3_contents.zip lambda/GetS3Contents && \
	zip -r -q temp/get_signed_url.zip lambda/GetSignedUrl && \
	cd terraform && terraform destroy && \
	cd .. && \
	rm temp/get_s3_contents.zip && \
	rm temp/get_signed_url.zip

