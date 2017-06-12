AWS CloudFront CLI
==================

Simple bash script to invalidate AWS CloudFront files.

## Example

    export AWS_DISTRIBUTION_ID=<YOUR_AWS_DISTRIBUTION_ID>
    export AWS_ACCESS_KEY=<YOUR_AWS_ACCESS_KEY>
    export AWS_SECRET_KEY=<YOUR_AWS_SECRET_KEY>
    bash ./aws-cloudfront-cli.bash /nav/logo.png /nav/logo2.png /nav/logo3.png

