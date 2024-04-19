import io.deephaven.parquet.table.ParquetTools
import io.deephaven.parquet.table.ParquetInstructions
import io.deephaven.extensions.s3.S3Instructions
import io.deephaven.extensions.s3.Credentials

def parquetSource = System.env['PARQUET_SOURCE'] ?: 'file:///file.parquet'

if (parquetSource.startsWith('s3:')) {
    // Following the AWS CLI convention for environment variables
    // https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
    def region = System.env['AWS_REGION'] ?: System.env['AWS_DEFAULT_REGION']
    def accessKeyId = System.env['AWS_ACCESS_KEY_ID']
    def secretAccessKey = System.env['AWS_SECRET_ACCESS_KEY']
    def endpointUrl = System.env['AWS_ENDPOINT_URL']
    def builder = S3Instructions.builder()
    builder.readTimeout(java.time.Duration.parse("PT10s"))
    builder.fragmentSize(65536)
    builder.readAheadCount(8)
    if (region != null) {
        builder.regionName(region)
    }
    if (endpointUrl != null) {
        builder.endpointOverride(endpointUrl)
    }
    if (accessKeyId != null) {
        builder.credentials(Credentials.basic(accessKeyId, secretAccessKey))
    } else {
        builder.credentials(Credentials.anonymous())
    }
    def s3Instructions = builder.build()
    def parquetInstructions = ParquetInstructions.builder()
        .setSpecialInstructions(s3Instructions)
        .build()
    parquet_table = ParquetTools.readTable(parquetSource, parquetInstructions)
} else {
    parquet_table = ParquetTools.readTable(parquetSource)
}