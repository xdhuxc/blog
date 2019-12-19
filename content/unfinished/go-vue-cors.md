







```markdown
Access to XMLHttpRequest at 'http://localhost:8088/echo/hello/info?t=1559210528534' from origin 'http://localhost:9528' has been blocked by CORS policy: The value of the 'Access-Control-Allow-Origin' header in the response must not be the wildcard '*' when the request's credentials mode is 'include'. The credentials mode of requests initiated by the XMLHttpRequest is controlled by the withCredentials attribute.
```


```markdown
Access to XMLHttpRequest at 'http://localhost:8088/echo/hello/info?t=1559210155487' from origin 'http://localhost:9528' has been blocked by CORS policy: The 'Access-Control-Allow-Origin' header contains the invalid value '127.0.0.1'.
```

```markdown
Access to XMLHttpRequest at 'http://localhost:8088/apps/info?t=1559212707044' from origin 'http://localhost:9528' has been blocked by CORS policy: No 'Access-Control-Allow-Origin' header is present on the requested resource.
```
```markdown
	// 添加过滤器以允许 COTS
	cors := restful.CrossOriginResourceSharing{
		AllowedDomains: []string{},
		AllowedHeaders: []string{"Upgrade", "Sec-WebSocket-Version", "Sec-WebSocket-Key", "Sec-WebSocket-Extensions", "Connection", "Accept", "Content-Type", "Content-Length", "Accept-Encoding", "X-CSRF-Token", "Authorization"},
		AllowedMethods: []string{"GET", "POST", "OPTIONS", "DELETE", "PUT"},
		CookiesAllowed: false,
		Container: container,
	}

	container.Filter(cors.Filter)
	container.Filter(container.OPTIONSFilter)
```
AllowedDomains 字段为空，表示允许所有的域。
