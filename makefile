deploy:
	cd lambda/GetS3Contents && \
	rm -rf node_modules && \
	npm i --production && \
	zip -r -q ../../get_s3_contents.zip * && \
	rm -rf node_modules && \
	npm i && \
	cd ../../ && \
	cd lambda/GetSignedUrl && \
	rm -rf node_modules && \
	npm i --production && \
	zip -r -q ../../get_signed_url.zip * && \
	rm -rf node_modules && \
	npm i && \
	cd ../.. && \
	cd terraform/code && \
	terraform apply --var-file=env/dev.tfvars -input=false -auto-approve && \
	cd ../.. && \
	rm get_s3_contents.zip && \
	rm get_signed_url.zip

destroy:
	cd lambda/GetS3Contents && \
	zip -r -q ../../get_s3_contents.zip * && \
	cd ../../ && \
	cd lambda/GetSignedUrl && \
	zip -r -q ../../get_signed_url.zip * && \
	cd ../.. && \
	cd terraform/code && terraform destroy --var-file=env/dev.tfvars  -input=false -auto-approve && \
	cd ../.. && \
	rm get_s3_contents.zip && \
	rm get_signed_url.zip

