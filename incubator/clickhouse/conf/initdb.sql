CREATE DATABASE IF NOT EXISTS test;
USE test;
CREATE TABLE IF NOT EXISTS test.ConversionEvents
(
    OrderId String,
    OccurredOn DEFAULT toDate(OccurredAt),
    OccurredAt DateTime,
    CompletedAt Nullable(DateTime),
    IsCompleted DEFAULT isNotNull(CompletedAt),
    Browser Nullable(String),
    Os Nullable(String),
    Country Nullable(String),
    Device Nullable(String),
    MerchantId Nullable(String),
    MerchantName Nullable(String),
    Impl String
) ENGINE = MergeTree(OccurredOn, (IsCompleted, OccurredOn), 8192);
CREATE TABLE IF NOT EXISTS test.Metrics
(
    Name String,
    PartitionDate Date DEFAULT toDate(Time),
    Time DateTime,
    Value Float32,
    Dimensions Nested(
    Key String,
    Value Nullable(String))
) ENGINE = MergeTree(PartitionDate, (Name, PartitionDate), 8192);
CREATE VIEW IF NOT EXISTS test.MetricsPivot AS
SELECT
    Name,
    PartitionDate,
    Time,
    (now() - Time) AS Age,
    1.84135 - 0.287552 * log(Age) AS PTemp,
    PTemp < 0 ? 0 : (PTemp > 1 ? 1 : PTemp) AS P,
    Name == 'conversion_rate.mgs.sessions' ? 1 : 0 AS SessionCount,
    Name == 'conversion_rate.mgs.sessions' ? P : 0 AS SessionP,
    Name == 'conversion_rate.mgs.conversions' ? 1 : 0 AS ConversionCount,
    Name == 'conversion_rate.mgs.conversions' ? P : 0 AS ConversionP,
    arrayElement(Dimensions.Value, indexOf(Dimensions.Key, 'browser')) AS Browser,
    arrayElement(Dimensions.Value, indexOf(Dimensions.Key, 'os')) AS Os,
    arrayElement(Dimensions.Value, indexOf(Dimensions.Key, 'country')) AS Country,
    arrayElement(Dimensions.Value, indexOf(Dimensions.Key, 'device')) AS Device,
    arrayElement(Dimensions.Value, indexOf(Dimensions.Key, 'merchantId')) AS MerchantId,
    arrayElement(Dimensions.Value, indexOf(Dimensions.Key, 'merchantName')) AS MerchantName
FROM test.Metrics
WHERE Name IN ('conversion_rate.mgs.sessions', 'conversion_rate.mgs.conversions');
