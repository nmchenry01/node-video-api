deploy:
	zip -r -q temp/get_s3_contents.zip lambda/GetS3Contents && \
	zip -r -q temp/get_signed_url.zip lambda/GetSignedUrl && \
	cd terraform/code && \
	terraform apply --var-file=env/dev.tfvars -input=false -auto-approve && \
	cd ../.. && \
	rm temp/get_s3_contents.zip &&\
	rm temp/get_signed_url.zip

destroy:
	zip -r -q temp/get_s3_contents.zip lambda/GetS3Contents && \
	zip -r -q temp/get_signed_url.zip lambda/GetSignedUrl && \
	cd terraform/code && terraform destroy --var-file=env/dev.tfvars  -input=false -auto-approve && \
	cd ../.. && \
	rm temp/get_s3_contents.zip && \
	rm temp/get_signed_url.zip

