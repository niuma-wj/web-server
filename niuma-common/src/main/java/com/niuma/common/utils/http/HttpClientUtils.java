package com.niuma.common.utils.http;

import com.alibaba.fastjson2.JSON;
import org.apache.http.Consts;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.impl.conn.PoolingHttpClientConnectionManager;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.springframework.util.StringUtils;

import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * HttpClient 工具类
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.11.02
 */
public final class HttpClientUtils {
    public static final String APPLICATION_JSON_VALUE = "application/json";
    private static final Integer CONN_TIME_OUT = 3000;// 超时时间豪秒
    private static final Integer SOCKET_TIME_OUT = 10000;

    /**
     * 每个路由的最大请求数，默认2
     */
    private static final Integer DEFAULT_MAX_PER_ROUTE = 40;

    /**
     * 最大连接数，默认20
     */
    private static final Integer MAX_TOTAL = 400;


    private static HttpClient httpClient;

    static {
        // 请求配置
        RequestConfig requestConfig = RequestConfig.custom()
                .setConnectTimeout(CONN_TIME_OUT)
                .setConnectionRequestTimeout(CONN_TIME_OUT)
                .setSocketTimeout(SOCKET_TIME_OUT)
                .build();

        // 管理 http连接池
        PoolingHttpClientConnectionManager cm = new PoolingHttpClientConnectionManager();
        cm.setDefaultMaxPerRoute(DEFAULT_MAX_PER_ROUTE);
        cm.setMaxTotal(MAX_TOTAL);

        httpClient = HttpClients.custom().setConnectionManager(cm).setDefaultRequestConfig(requestConfig).build();
    }

    public static HttpResult get(String url, Map<String, Object> headers, Map<String, Object> params) throws Exception {
        // Get请求
        HttpGet httpGet = new HttpGet(url);
        RequestConfig requestConfig = RequestConfig.custom()
                .setConnectTimeout(20000).setConnectionRequestTimeout(1000)
                .setSocketTimeout(5000).build();
        httpGet.setConfig(requestConfig);
        try {
            // 设置参数
            if ((headers != null) && (headers.size() > 0)) {
                for (Map.Entry<String, Object> entry : headers.entrySet())
                    httpGet.setHeader(entry.getKey(), entry.getValue().toString());
            }
            if ((params != null) && (params.size() > 0)) {
                List<NameValuePair> paramList = initParams(params);
                String str = EntityUtils.toString(new UrlEncodedFormEntity(paramList, StandardCharsets.UTF_8));
                String uriStr = null;
                if (StringUtils.hasLength(str))
                    uriStr = httpGet.getURI().toString() + "?" + str;
                else
                    uriStr = httpGet.getURI().toString();
                httpGet.setURI(new URI(uriStr));
            }
            // 发送请求
            HttpResponse response = httpClient.execute(httpGet);
            // 获取返回数据
            return getHttpResult(response, url);
        } catch (Exception ex) {
            throw ex;
        } finally {
            // 必须释放连接，否则连接用完后会阻塞
            httpGet.releaseConnection();
        }
    }

    /**
     * POST表单
     * @param url 请求地址
     * @param headers 请求头
     * @param params 地址参数
     * @param table 提交表单
     * @return 响应结果
     */
    public static HttpResult post(String url, Map<String, Object> headers, Map<String, Object> params, Map<String, Object> table) throws Exception {
        // Post请求
        HttpPost httpPost = new HttpPost(url);
        RequestConfig requestConfig = RequestConfig.custom()
                .setConnectTimeout(20000).setConnectionRequestTimeout(1000)
                .setSocketTimeout(5000).build();
        httpPost.setConfig(requestConfig);
        try {
            List<NameValuePair> paramList = null;
            // 地址参数
            if ((params != null) && !params.isEmpty()) {
                paramList = initParams(params);
                String str = EntityUtils.toString(new UrlEncodedFormEntity(paramList, StandardCharsets.UTF_8));
                String uriStr = null;
                if (StringUtils.hasLength(str))
                    uriStr = httpPost.getURI().toString() + "?" + str;
                else
                    uriStr = httpPost.getURI().toString();
                httpPost.setURI(new URI(uriStr));
            }
            // 请求头
            if ((headers != null) && !headers.isEmpty()) {
                for (Map.Entry<String, Object> entry : headers.entrySet())
                    httpPost.setHeader(entry.getKey(), entry.getValue().toString());
            }
            // 提交表单
            if ((table != null) && !table.isEmpty()) {
                paramList = initParams(params);
                httpPost.setEntity(new UrlEncodedFormEntity(paramList, Consts.UTF_8));
            }
            // 发送请求
            HttpResponse response = httpClient.execute(httpPost);

            return getHttpResult(response, url);
        } catch (Exception ex) {
            throw ex;
        } finally {
            httpPost.releaseConnection();
        }
    }

    /**
     * POST json 格式数据
     */
    public static HttpResult postJson(String url, Map<String, Object> headers, Map<String, Object> params) throws Exception {
        // Post请求
        HttpPost httpPost = new HttpPost(url);
        RequestConfig requestConfig = RequestConfig.custom()
                .setConnectTimeout(20000)
                .setConnectionRequestTimeout(1000)
                .setSocketTimeout(5000)
                .build();
        httpPost.setConfig(requestConfig);
        try {
            if (headers != null) {
                for (Map.Entry<String, Object> entry : headers.entrySet())
                    httpPost.setHeader(entry.getKey(), entry.getValue().toString());
            }
            String json = JSON.toJSONString(params);
            StringEntity entity = new StringEntity(json, Consts.UTF_8);
            entity.setContentType(APPLICATION_JSON_VALUE);
            httpPost.setEntity(entity);
            // 发送请求
            HttpResponse response = httpClient.execute(httpPost);
            return getHttpResult(response, url);
        } catch (Exception ex) {
            throw ex;
        } finally {
            // 资源释放
            httpPost.releaseConnection();
        }
    }

    private static HttpResult getHttpResult(HttpResponse response, String url) throws Exception {
        HttpResult result = new HttpResult();
        // 检验状态码，如果成功接收数据
        int code = response.getStatusLine().getStatusCode();
        String body = EntityUtils.toString(response.getEntity(), Consts.UTF_8);
        result.setCode(code);
        result.setBody(body);
        return result;
    }

    private static List<NameValuePair> initParams(Map<String, Object> params) {
        List<NameValuePair> paramList = new ArrayList<NameValuePair>();
        if (params == null)
            return paramList;
        for (Map.Entry<String, Object> entry : params.entrySet()) {
            if ((entry.getKey() == null) || (entry.getValue() == null))
                continue;
            paramList.add(new BasicNameValuePair(entry.getKey(), entry.getValue().toString()));
        }
        return paramList;
    }
}