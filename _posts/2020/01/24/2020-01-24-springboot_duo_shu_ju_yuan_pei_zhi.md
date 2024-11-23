---
title: "Spring Boot 多数据源配置"
date: 2020-01-24 15:05:00 +0800
last_modified_at: 2020-01-24 15:50:58 +0800
math: false
render_with_liquid: false
categories: ["程序人生", "Java"]
tags: ["java", "spring boot"]
description: "有的时候在项目里可能会同时使用多个数据库，此时 Spring Boot 提供的 application.yml 已无法满足需求，需在代码中进行手动配置。原文链接：blog.lucien.ink/archives/487"
---

## Spring Boot 多数据源配置

有的时候在项目里可能会同时使用多个数据库，此时 Spring Boot 提供的 application.yml 已无法满足需求，需在代码中进行手动配置。

### 1. 原文链接

[blog.lucien.ink/archives/487](https://blog.lucien.ink/archives/487/)

### 2. 解析

Spring Boot 与数据库之间通过 `DataSource` 进行连接，`Mapper` 与 `DataSource` 之间通过 `SqlSessionTemplate` 进行连接。

`Mapper` -> `SqlSessionTemplate` -> `DataSource` -> `Database`

### 3. 代码

#### 3.1 DataSource

[cn.pasteme.admin.configuration.PasteMeAdminDataSourceConfiguration](https://github.com/PasteUs/PasteMeAdmin/blob/b19215dcb9c4a6eb2449266dca8418d005f3b9b3/src/main/java/cn/pasteme/admin/configuration/PasteMeAdminDataSourceConfiguration.java)

```java
package cn.pasteme.admin.configuration;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.sql.DataSource;

/**
 * @author Lucien
 * @version 1.0.0
 */
@Configuration
public class PasteMeAdminDataSourceConfiguration {

    @Bean(name = "mysql")
    @ConfigurationProperties(prefix = "spring.datasource.mysql")
    public DataSource mysql() {
        return DataSourceBuilder.create().build();
    }

    @Bean(name = "sqlite")
    @ConfigurationProperties(prefix = "spring.datasource.sqlite")
    public DataSource sqlite() {
        return DataSourceBuilder.create().build();
    }
}
```

#### 3.2 MapperConfiguration

##### 3.2.1 MySQL

[cn.pasteme.admin.configuration.PasteMeCommonMapperConfiguration](https://github.com/PasteUs/PasteMeAdmin/blob/b19215dcb9c4a6eb2449266dca8418d005f3b9b3/src/main/java/cn/pasteme/admin/configuration/PasteMeCommonMapperConfiguration.java)

```java
package cn.pasteme.admin.configuration;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.sql.DataSource;

/**
 * @author Lucien
 * @version 1.0.0
 */
@Configuration
@MapperScan(basePackages = {"cn.pasteme.common.mapper"}, sqlSessionFactoryRef = "mysqlSessionFactory", sqlSessionTemplateRef = "mysqlSessionTemplate")
public class PasteMeCommonMapperConfiguration {

    private final DataSource dataSource;

    public PasteMeCommonMapperConfiguration(@Qualifier("mysql") DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Bean
    public SqlSessionFactory mysqlSessionFactory() throws Exception {
        SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
        sqlSessionFactoryBean.setDataSource(dataSource);
        return sqlSessionFactoryBean.getObject();
    }

    @Bean
    public SqlSessionTemplate mysqlSessionTemplate() throws Exception {
        return new SqlSessionTemplate(mysqlSessionFactory());
    }
}
```

##### 3.2.2 SQLite

[cn.pasteme.admin.configuration.PasteMeAdminMapperConfiguration](https://github.com/PasteUs/PasteMeAdmin/blob/b19215dcb9c4a6eb2449266dca8418d005f3b9b3/src/main/java/cn/pasteme/admin/configuration/PasteMeAdminMapperConfiguration.java)

```java
package cn.pasteme.admin.configuration;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.sql.DataSource;

/**
 * @author Lucien
 * @version 1.0.0
 */
@Configuration
@MapperScan(basePackages = {"cn.pasteme.admin.mapper"}, sqlSessionFactoryRef = "sqliteSessionFactory", sqlSessionTemplateRef = "sqliteSessionTemplate")
public class PasteMeAdminMapperConfiguration {

    private final DataSource dataSource;

    public PasteMeAdminMapperConfiguration(@Qualifier("sqlite") DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Bean
    public SqlSessionFactory sqliteSessionFactory() throws Exception {
        SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
        sqlSessionFactoryBean.setDataSource(dataSource);
        return sqlSessionFactoryBean.getObject();
    }

    @Bean
    public SqlSessionTemplate sqliteSessionTemplate() throws Exception {
        return new SqlSessionTemplate(sqliteSessionFactory());
    }
}
```
