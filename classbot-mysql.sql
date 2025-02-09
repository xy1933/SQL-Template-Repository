/*
 * @Author: Melodyknit 2711402357@qq.com
 * @Date: 2023-05-25 13:50:37
 * @LastEditors: Melodyknit 2711402357@qq.com
 * @LastEditTime: 2023-05-25 16:35:23
 * @FilePath: classbot-mysql.sql
 * @Description: MySQL表结构
 */

-- Active: 1683853788210@@127.0.0.1@3306@classbot

CREATE DATABASE
    IF NOT EXISTS classbot DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE classbot;

-- 教师表

CREATE TABLE
    IF NOT EXISTS teacher (
        id INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY COMMENT '教师id',
        qq BIGINT NOT NULL UNIQUE COMMENT '教师qq号',
        name VARCHAR(20) NOT NULL COMMENT '教师姓名',
        creator VARCHAR(100) NOT NULL COMMENT '谁邀请的',
        phone BIGINT NOT NULL UNIQUE COMMENT '教师电话',
        email VARCHAR(100) NULL UNIQUE COMMENT '教师邮箱'
    ) COMMENT '教师表';

-- 学院表

CREATE TABLE
    IF NOT EXISTS college (
        id INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY COMMENT '学院id',
        college VARCHAR(100) NOT NULL UNIQUE COMMENT '院系名称',
        creator VARCHAR(100) NOT NULL COMMENT '添加人'
    ) COMMENT '学院表';

-- 专业表

CREATE TABLE
    IF NOT EXISTS major (
        id INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY COMMENT '专业id',
        college INT NOT NULL COMMENT '学院id',
        major VARCHAR(100) NOT NULL UNIQUE COMMENT '专业名称',
        creator VARCHAR(100) NOT NULL COMMENT '添加人',
        FOREIGN KEY (college) REFERENCES college(id)
    ) COMMENT '专业表';

-- 班级表

CREATE TABLE
    IF NOT EXISTS class_table (
        id INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY COMMENT '班级id',
        group_id BIGINT NOT NULL UNIQUE COMMENT '班级QQ群',
        name VARCHAR(100) NOT NULL UNIQUE COMMENT '班级群名',
        teacher INT NOT NULL COMMENT '教师id',
        major INT NOT NULL COMMENT '专业id',
        FOREIGN KEY (teacher) REFERENCES teacher(id),
        FOREIGN KEY (major) REFERENCES major(id)
    ) COMMENT '班级表';

-- 学生表

CREATE TABLE
    IF NOT EXISTS student (
        QQ BIGINT NOT NULL UNIQUE PRIMARY KEY COMMENT 'QQ',
        name VARCHAR(20) NOT NULL COMMENT '学生姓名',
        class_table INT NOT NULL COMMENT '学生班级',
        student_id BIGINT NULL UNIQUE COMMENT '学号',
        phone BIGINT NULL UNIQUE COMMENT "联系方式",
        id_card VARCHAR(20) NULL UNIQUE COMMENT '身份证号',
        wechat VARCHAR(100) NULL UNIQUE COMMENT '微信号',
        email VARCHAR(100) NULL UNIQUE COMMENT '邮箱',
        position VARCHAR(50) NOT NULL DEFAULT '学生' COMMENT '学生',
        sex VARCHAR(10) NULL COMMENT '性别',
        class_order INT NULL COMMENT '个人在班级中的顺序',
        birthday TIMESTAMP NULL COMMENT '出生日期',
        dorm VARCHAR(20) NULL COMMENT '寝室',
        dorm_head BOOLEAN NOT NULL DEFAULT FALSE COMMENT '寝室长',
        ethnic VARCHAR(200) NULL COMMENT '民族',
        birthplace VARCHAR(200) NULL COMMENT '籍贯',
        politics VARCHAR(50) NULL COMMENT '政治面貌',
        address VARCHAR(200) NULL COMMENT '家庭住址',
        FOREIGN KEY (class_table) REFERENCES class_table(id)
    ) COMMENT '学生表';

-- 德育日志

CREATE TABLE
    IF NOT EXISTS moral_education (
        id INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY COMMENT '德育日志id',
        class_table INT NOT NULL COMMENT '班级id',
        qq BIGINT NOT NULL COMMENT '学生qq',
        activity_type VARCHAR(50) NULL COMMENT '分数类型',
        description TEXT NOT NULL COMMENT '解释原因原因',
        score INT NOT NULL DEFAULT 0 COMMENT '加减的分数',
        create_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '日志时间',
        prove VARCHAR(255) NULL COMMENT "证明文件",
        FOREIGN KEY (class_table) REFERENCES class_table(id),
        FOREIGN KEY (qq) REFERENCES student(qq)
    ) COMMENT "德育日志";

-- 班级任务

CREATE TABLE
    IF NOT EXISTS class_tasks (
        id INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY COMMENT '任务id',
        title VARCHAR(255) NOT NULL COMMENT '任务标题',
        task_type VARCHAR(255) NOT NULL COMMENT '任务类型',
        class_table INT NOT NULL COMMENT '班级id',
        creator VARCHAR(100) NOT NULL COMMENT '创建人',
        completed BOOLEAN NOT NULL DEFAULT FALSE COMMENT '是否已经完成',
        create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
        FOREIGN KEY (class_table) REFERENCES class_table(id)
    ) COMMENT '班级任务表';

-- 任务文件

CREATE TABLE
    IF NOT EXISTS task_files (
        id INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY COMMENT '文件id',
        class_tasks INT NOT NULL COMMENT '收取标题',
        student BIGINT NOT NULL COMMENT '提交人QQ',
        file_md5 VARCHAR(255) NOT NULL COMMENT '文件名称md5',
        push_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
        FOREIGN KEY (class_tasks) REFERENCES class_tasks(id),
        FOREIGN KEY (student) REFERENCES student(qq)
    ) COMMENT '任务文件表';

-- 班费表

CREATE TABLE
    IF NOT EXISTS class_funds (
        class_table INT NOT NULL COMMENT '班级id',
        description TEXT NOT NULL COMMENT '费用所花费在某件事情',
        money DOUBLE NOT NULL COMMENT '花费金额',
        create_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
        creator VARCHAR(100) NOT NULL COMMENT '费用记录人',
        FOREIGN KEY (class_table) REFERENCES class_table(id)
    ) COMMENT '班费表';