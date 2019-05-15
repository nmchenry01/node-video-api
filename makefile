# TODO: Add workspace select command to deploy and destroy
# TODO: Add parameter for env for deploy and destroy

init:
	cd terraform/code && \
	terraform init -backend-config="env/backendConfig" && \
	terraform workspace new DEV && \
	terraform workspace new QA && \
	terraform workspace new PROD

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

