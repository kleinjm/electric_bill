# Uploading to AWS Lambda
## Functions
Zip function
`zip -j lambda/function.zip lambda/lambda_function.rb`
Then upload with
`aws lambda update-function-code --function-name xcel-bill-parser --zip-file fileb://lambda/function.zip`

## Layers
After making a change to the libs, update the lambda layer. Zip the files with the following
`zip library.zip lib/**/*`
`aws lambda publish-layer-version --layer-name library --zip-file fileb://library.zip`

After updating gems
`zip -r gems.zip vendor`
`aws lambda publish-layer-version --layer-name gems --zip-file fileb://gems.zip`
