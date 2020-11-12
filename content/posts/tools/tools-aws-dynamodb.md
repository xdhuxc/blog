+++
title = "AWS DynamoDB 简单使用"
date = "2019-06-02"
lastmod = "2019-06-02"
tags = [
    "AWS"
]
categories = [
    "技术"
]
+++

本篇博客记录下使用 AWS DynamoDB 过程中用到的一些知识和技术点，以备后需。

<!--more-->

Amazon DynamoDB 是一个键/值和文档数据库，可以在任何规模的环境中提供个位数的毫秒级性能。它是一个完全托管的多区域多主数据库，具有适用于 Internet 规模的应用程序的内置安全性、备份和恢复和内存缓存。DynamoDB 每天可处理超过 10 万亿个请求，并可支持每秒超过 2000 万个请求的峰值。

### 使用 docker 本地部署 DynamoDB
使用 docker 容器本地部署 DynamoDB 实例
```markdown
docker run -d -p 8000:8000 amazon/dynamodb-local
```

### 使用命令行操作 DynamoDB
执行 aws 命令前，需要在 ~/.aws/credentials 中配置访问 DynamoDB 的 Access Key 和 Secret Key，如下所示：
```markdown
[default]
aws_access_key_id = ${aws_access_key_id}
aws_secret_access_key = ${aws_access_key_id}
```
在 ~/.aws/config 中配置区域，如下所示：
```markdown
[default]
region = ap-southeast-1
```
如果是本地启动的 DynamoDB 实例，只需任意一个合法的 DynamoDB Access Key 和 Secret Key 即可。

1、显示所有数据库表
```markdown
aws dynamodb list-tables --endpoint-url http://localhost:8000
```

2、显示特定表信息
```markdown
aws dynamodb describe-table --table-name xdhuxc --endpoint-url http://localhost:8000
```

3、创建表
```markdown
aws dynamodb create-table \
    --table-name xdhuxc \
    --attribute-definitions \
        AttributeName=key,AttributeType=S \
    --key-schema \
        AttributeName=key,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=10,WriteCapacityUnits=10 \
    --endpoint-url http://localhost:8000
```

4、插入 JSON 格式数据
```markdown
aws dynamodb put-item --table-name xdhuxc \
    --item '{ "key": { "S": "/myapp/study/hosts/codelieche" }, "value": {"S": "{\"domain\": \"www.codelieche.com\", \"ip\": \"192.168.1.101\"}" }}' \
    --endpoint-url http://localhost:8000
    
aws dynamodb put-item --table-name xdhuxc \
    --item '{ "key": { "S": "/myapp/study/hosts/codelieche2" }, "value": {"S": "{\"domain\": \"www.codelieche.com\", \"ip\": \"192.168.1.101\"}"}}' \
    --endpoint-url http://localhost:8000
```

5、查看 dynamodb 数据库中所有数据
```angular2html
aws dynamodb scan --table-name xdhuxc --endpoint-url http://localhost:8000
```

### 使用 golang 操作 DynamoDB 
可以使用 AWS 提供的 golang SDK 来操作 DynamoDB，实现在我们的程序内部对 DynamoDB 的调用。

注意，执行批量操作时，有数据量限制，每次只能增删 25 条数据，多余的将会报错（BatchLimit = 25）。

1、创建 dynamodb 客户端，对 DynamoDB 的操作都要使用该客户端来进行。
```markdown
func NewDynamoDBClient(region string, endpoint string, disableSSL bool) (*dynamodb.DynamoDB, error) {
	if region == "" {
		sess, err := session.NewSession()
		if err != nil {
			return nil, err
		}
		metadata := ec2metadata.New(sess)
		ec2Region, err := metadata.Region()
		if err != nil {
			return nil, fmt.Errorf("aws DynamoDB requires a region")
		}
		region = ec2Region
	}
	var c *aws.Config
	// 使用环境变量中的 AccessKey 和 SecretKey
	accessKey := os.Getenv("AWS_ACCESS_KEY_ID")
	secretKey := os.Getenv("AWS_SECRET_ACCESS_KEY")
	if accessKey != "" && secretKey != "" {
		creds := credentials.NewStaticCredentials(accessKey, secretKey, "")
		c = &aws.Config{
			Region:      aws.String(region),
			Credentials: creds,
			Endpoint:    aws.String(endpoint),
			DisableSSL:  aws.Bool(disableSSL),
		}
	} else if accessKey != "" && secretKey != "" { // 使用配置文件中的 AccessKey 和 SecretKey
		creds := credentials.NewStaticCredentials(accessKey, secretKey, "")
		c = &aws.Config{
			Region:      aws.String(region),
			Credentials: creds,
			Endpoint:    aws.String(endpoint),
			DisableSSL:  aws.Bool(disableSSL),
		}
	} else {
		c = &aws.Config{ // 使用 ~/.aws/credentials 文件中的 AccessKey 和 SecretKey 。
			Region:     aws.String(region),
			Endpoint:   aws.String(endpoint),
			DisableSSL: aws.Bool(disableSSL),
		}
	}

	sess, err := session.NewSession(c)
	if err != nil {
		return nil, err
	}

	db := dynamodb.New(sess)

	return db, nil
}
```

2、创建表 
```markdown
func CreateTable(ddb *dynamodb.DynamoDB, tableName string) error {
	itemInput := &dynamodb.CreateTableInput{
		AttributeDefinitions: []*dynamodb.AttributeDefinition{
			{
				AttributeName: aws.String("key"),
				AttributeType: aws.String("S"),
			},
		},
		KeySchema: []*dynamodb.KeySchemaElement{
			{
				AttributeName: aws.String("key"),
				KeyType:       aws.String("HASH"),
			},
		},
		ProvisionedThroughput: &dynamodb.ProvisionedThroughput{
			ReadCapacityUnits:  aws.Int64(10),
			WriteCapacityUnits: aws.Int64(10),
		},
		TableName: aws.String(tableName),
	}
	_, err := ddb.CreateTable(itemInput)
	if err != nil {
		return err
	}

	return nil
}
```

3、向 dynamodb 表中插入键值对
```markdown
func insert2DynamoDB(ddb *dynamodb.DynamoDB, tableName string, key string, value string) error {
 	itemInput := &dynamodb.PutItemInput{
 		TableName: aws.String(tableName),
 		Item: map[string]*dynamodb.AttributeValue{
 			"key": {                 // 注意，建表时键名起为 key。
 				S: aws.String(key),
 			},
 			"value": {
 				S: aws.String(value),
         			},
 		},
 	}

 	if _, err := ddb.PutItem(itemInput); err != nil {
 		return err
 	}
 	return nil
 }
```
4、向 dynamodb 表中批量插入键值数据
```markdown
func batchWrite2DynamoDB(ddb *dynamodb.DynamoDB, tableName string, data map[string]string) error {
	requestItems := make(map[string][]*dynamodb.WriteRequest)
	length := len(data)
	var writeRequests []*dynamodb.WriteRequest
	count := 0
	writeRequests = []*dynamodb.WriteRequest{}
	for key, value := range data {// 键值数据
		var writeRequest *dynamodb.WriteRequest
		writeRequest = &dynamodb.WriteRequest{
			PutRequest: &dynamodb.PutRequest{
				Item: map[string]*dynamodb.AttributeValue{
					"key": {
						S: aws.String(key),
					},
					"value": {
						S: aws.String(value),
					},
				},
			},
		}
		writeRequests = append(writeRequests, writeRequest)
		count = count + 1

		if (count % utils.BatchLimit == 0) || (count >= length) {
			requestItems[tableName] = writeRequests
			batchInput := &dynamodb.BatchWriteItemInput{
				RequestItems: requestItems,
			}

			if _, err := ddb.BatchWriteItem(batchInput); err != nil {
				return err
			}
			writeRequests = []*dynamodb.WriteRequest{}
		}
	}

	return nil
}
```

5、批量删除数据
此处是通过批量删除的方式删除了全部数据，但是保留了表结构，之所以没有采用删除表的操作，是因为线上环境，权限所限
```markdown
func BatchDeleteItems(ddb *dynamodb.DynamoDB, tableName string) error {
	errc := make(chan error, 1)
	wg := sync.WaitGroup{}

	scannedData, err := ddb.Scan(&dynamodb.ScanInput{TableName: aws.String(tableName)})
	if err != nil {
		return err
	}

	length := len(scannedData.Items)
	wg.Add(int(math.Ceil((float64(length)) / float64(utils.BatchLimit))))

	req := []*dynamodb.WriteRequest{}
	for i, a := range scannedData.Items {
		req = append(req, &dynamodb.WriteRequest{
			DeleteRequest: &dynamodb.DeleteRequest{
				Key: map[string]*dynamodb.AttributeValue{
					"key": a["key"],
				},
			},
		})
		if (i+1) % utils.BatchLimit == 0 || i >= int(*scannedData.Count)-1 {
			go func(reqChunk []*dynamodb.WriteRequest) {
				defer wg.Done()
				_, err := t.DdbClient.BatchWriteItem(&dynamodb.BatchWriteItemInput{
					RequestItems: map[string][]*dynamodb.WriteRequest{
						t.TableName: reqChunk,
					},
				})
				if err != nil {
					errc <- err
				}
			}(req)
			req = []*dynamodb.WriteRequest{}
		}
	}
	go func() {
		wg.Wait()
		close(errc)
	}()
	return <-errc
}
```

6、删除数据表
```markdown
func DeleteTable(ddb *dynamodb.DynamoDB, tableName string) error {
	itemInput := &dynamodb.DeleteTableInput{
		TableName: aws.String(tableName),
	}

	if _, err := ddb.DeleteTable(itemInput); err != nil {
		return err
	}
	return nil
}
```

### 参考资料

https://hub.docker.com/r/amazon/dynamodb-local

https://docs.aws.amazon.com/zh_cn/amazondynamodb/latest/developerguide/DynamoDBLocal.DownloadingAndRunning.html

https://docs.aws.amazon.com/sdk-for-go/api/service/dynamodb/
