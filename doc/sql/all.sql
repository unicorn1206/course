drop table if exists `role`;
create table `role`(
                       id char(8) not null default '' comment 'id',
                       name varchar(50) not null comment '角色',
                       `desc` varchar(100) not null comment '描述',
                       primary key (id)
)engine=innodb default charset=utf8mb4 comment ='角色';
insert into `role` values ('00000000','系统管理员','管理用户、角色权限');
insert into `role` values ('00000001','开发','维护资源');
insert into `role` values ('00000002','业务管理员','负责业务管理');

drop table if exists user;
create table user(
                     id char(8) not null default '' comment 'id',
                     login_name varchar(50) not null  comment '登录名',
                     name varchar(50) comment '昵称',
                     password char(32) not null comment '密码',
                     primary key (id),
                     unique key login_name_unique(login_name)
)engine=innodb default charset=utf8mb4 comment ='用户';
insert into user values ('10000000','test','测试','');

-- 资源
drop table if exists resource;
create table resource(
                     id char(6) not null default '' comment 'id',
                     name varchar(100) not null  comment '名称|菜单或按钮',
                     page varchar(50) null comment '页面|路由',
                     request char(200) null comment '请求|接口',
                     parent char(6) comment '父id',
                     primary key (id)
)engine=innodb default charset=utf8mb4 comment ='资源';
insert into resource values ('01','系统管理',null,null,null);
insert into resource values ('0101','用户管理','/system/user',null,'01');
insert into resource values ('010101','用户管理保存',null,'["/system/admin/user/list","/system/admin/user/save"]','0101');
insert into resource values ('010102','用户管理删除',null,'["/system/admin/user/delete"]','0101');
insert into resource values ('010103','用户管理重置密码',null,'["/system/admin/user/save-password"]','0101');
insert into resource values ('0102','资源管理','/system/resource',null,'01');
insert into resource values ('010201','资源管理保存/显示',null,'["/system/admin/resource"]','0102');
insert into resource values ('0103','角色管理','/system/role',null,'01');
insert into resource values ('010301','角色管理角色/权限管理',null,'["/system/admin/role"]','0103');

# 课程内容文件
drop table if exists course_content_file;
create table course_content_file(
                     id char(8) not null default '' comment 'id',
                     course_id char(8) not null  comment '课程id',
                     url varchar(100) comment '地址',
                     name varchar(100) comment '文件名',
                     size int comment '大小|字节B',
                     primary key (id)
)engine=innodb default charset=utf8mb4 comment ='课程内容文件';

drop table if exists file;
create table file(
    id char(8) not null default '' comment 'id',
    path varchar(100) not null  comment '相对路径',
    name varchar(100) comment '文件名',
    suffix varchar(10) comment '后缀',
    size int comment '大小|字节B',
    `use` char(1) comment '用途|枚举[FileUseEnum]:COURSE("C","课程"),TEACHER("T","讲师")',
    create_at datetime(3) comment '创建时间',
    update_at datetime(3) comment '更新时间',
    primary key (id),
    unique key path_unique(path)
)engine=innodb default charset=utf8mb4 comment ='文件';

alter table file add column(shard_index int comment '已上传分片');
alter table file add column(shard_size int comment '分片大小|B');
alter table file add column(shard_total int comment '分片总数');
alter table file add column(`key` varchar(32) comment '文件标识');
alter table file add unique key key_unique(`key`);


drop table if exists teacher;
create table teacher(
                               id char(8) not null default '' comment 'id',
                               name varchar(50) not null  comment '姓名',
                               nickname varchar(50) comment '昵称',
                               image varchar(100) comment '头像',
                               position varchar(50) comment '职位',
                               motto varchar(50) comment '座右铭',
                               intro varchar(500) comment '简介',
                               primary key (id)
)engine=innodb default charset=utf8mb4 comment ='讲师';

drop table if exists course_content;
create table course_content(
                                id char(8) not null default '' comment '课程id',
                                content mediumtext not null comment '课程内容',
                                primary key (id)
)engine=innodb default charset=utf8mb4 comment ='课程内容';

drop table if exists course_category;
create table course_category(
    id char(8) not null default '' comment 'id',
    course_id char(8) comment '课程|course.id',
    category_id char(8) comment '分类|course.id',
    primary key (id)
)engine=innodb default charset=utf8mb4 comment ='课程分类';

drop table if exists category;
create table category(
                         id char(8) not null default '' comment 'id',
                         parent char(8) not null default '' comment '父id',
                         name varchar(50) not null comment '名称',
                         sort int comment '顺序',
                         primary key (id)
)engine=innodb default charset=utf8mb4 comment ='分类';
insert into category values ('00000100','00000000','前端技术',100);
insert into category values ('00000101','00000100','html/css',101);
insert into category values ('00000102','00000100','javascript',102);
insert into category values ('00000103','00000100','vue.js',103);
insert into category values ('00000104','00000100','react.js',104);
insert into category values ('00000105','00000100','angular',105);
insert into category values ('00000106','00000100','node.js',106);
insert into category values ('00000107','00000100','jquery',107);
insert into category values ('00000108','00000100','小程序',108);
insert into category values ('00000200','00000000','后端技术',200);
insert into category values ('00000201','00000200','java',201);
insert into category values ('00000202','00000200','spring boot',202);
insert into category values ('00000203','00000200','spring cloud',203);
insert into category values ('00000204','00000200','ssm',204);
insert into category values ('00000205','00000200','python',205);
insert into category values ('00000206','00000200','爬虫',206);
insert into category values ('00000300','00000000','移动开发',300);
insert into category values ('00000301','00000300','android',301);
insert into category values ('00000302','00000300','ios',302);
insert into category values ('00000303','00000300','react native',303);
insert into category values ('00000304','00000300','ionic',304);
insert into category values ('00000400','00000000','前沿技术',400);
insert into category values ('00000401','00000400','微服务',401);
insert into category values ('00000402','00000400','区块链',402);
insert into category values ('00000403','00000400','机器学习',403);
insert into category values ('00000404','00000400','深度学习',404);
insert into category values ('00000405','00000400','数据分析&挖掘',405);
insert into category values ('00000500','00000000','云计算&大数据',500);
insert into category values ('00000501','00000500','大数据',501);
insert into category values ('00000502','00000500','hadoop',502);
insert into category values ('00000600','00000000','运维测试',600);
insert into category values ('00000601','00000600','运维',601);
insert into category values ('00000602','00000600','测试',602);
insert into category values ('00000700','00000000','数据库',702);
insert into category values ('00000701','00000700','oracle',701);
insert into category values ('00000702','00000700','mySql',702);

drop table if exists course;
create table course(
                        id char(8) not null default '' comment 'ID',
                        name varchar(50) not null comment '名称',
                        summary varchar(2000) comment '概述',
                        time int default 0 comment '时长|单位秒',
                        price decimal(8,2)  default 0.00 comment '价格（元）',
                        image varchar(100) comment '封面',
                        level char(1) comment '级别|枚举[CourseLevelEnum]:ONE("1", "初级"),TWO("2", "中级"),THREE("3", "高级")',
                        charge char(1) comment '收费|枚举[CourseChargeEnum]:CHARGE("C", "收费"),FREE("F", "免费")',
                        status char(1) comment '状态|枚举[CourseStatusEnum]:PUBLISH("P", "发布"),DRAFT("D", "草稿")',
                        enroll integer default 0 comment '报名数',
                        sort int comment '顺序',
                        create_at datetime(3) comment '创建时间',
                        update_at datetime(3) comment '更新时间',
                        primary key (id)
)engine=innodb default charset=utf8mb4 comment ='课程';
insert into course values('00000001','测试课程01','这是一门测试课程',7200,19.9,'',0,'C','D',100,0,now(),now());

alter table course add column (teacher_id char(8) comment'讲师｜teacher.id');

drop table if exists section;
create table section(
                        id char(8) not null default '' comment 'ID',
                        title varchar(50) not null comment '标题',
                        course_id char(8) comment '课程|course.id',
                        chapter_id char(8) comment '大章|chapter.id',
                        video varchar(200) comment '视频',
                        time int comment '时长|单位秒',
                        charge char(1) comment '收费|C 收费;F 免费',
                        sort int comment '顺序',
                        create_at datetime(3) comment '创建时间',
                        update_at datetime(3) comment '更新时间',
                        primary key (id)
)engine=innodb default charset=utf8mb4 comment ='小节';

insert into section values ('00000001','测试小节01','00000001','00000000','',500,'F',1,now(),now());

drop table if exists chapter;
create table chapter(
                        id char(8) not null comment 'ID',
                        course_id char(8) comment '课程ID',
                        name varchar(50) comment '名称',
                        primary key (id)
)engine=innodb default charset=utf8mb4 comment ='大章';

insert into chapter values ('00000001','00000000','测试大章1');
insert into chapter values ('00000002','00000001','测试大章2');
insert into chapter values ('00000003','00000000','测试大章3');
insert into chapter values ('00000004','00000000','测试大章4');
insert into chapter values ('00000005','00000000','测试大章5');
insert into chapter values ('00000006','00000000','测试大章6');
insert into chapter values ('00000007','00000000','测试大章7');
insert into chapter values ('00000008','00000000','测试大章8');
insert into chapter values ('00000009','00000000','测试大章9');
insert into chapter values ('00000010','00000000','测试大章10');
insert into chapter values ('00000011','00000000','测试大章11');
insert into chapter values ('00000012','00000001','测试大章12');
insert into chapter values ('00000013','00000001','测试大章13');
insert into chapter values ('00000014','00000001','测试大章14');
insert into chapter values ('00000015','00000001','测试大章15');
insert into chapter values ('00000016','00000001','测试大章16');
insert into chapter values ('00000017','00000001','测试大章17');
insert into chapter values ('00000018','00000001','测试大章18');
insert into chapter values ('00000019','00000001','测试大章19');