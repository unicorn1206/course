<template>
    <div class="main-container">
        <div class="main-content">
            <div class="row">
                <div class="col-sm-10 col-sm-offset-1">
                    <div class="login-container">
                        <div class="center">
                            <h1>
                                <i class="ace-icon fa fa-leaf green"></i>
                                <span class="">登录</span>
                            </h1>
                        </div>

                        <div class="space-6"></div>

                        <div class="position-relative">
                            <div id="login-box" class="login-box visible widget-box no-border">
                                <div class="widget-body">
                                    <div class="widget-main">
                                        <h4 class="header blue lighter bigger">
                                            <i class="ace-icon fa fa-coffee green"></i>
                                            请输入用户名密码
                                        </h4>

                                        <div class="space-6"></div>

                                        <form>
                                            <fieldset>
                                                <label class="block clearfix">
														<span class="block input-icon input-icon-right">
															<input type="text" class="form-control" v-model="user.loginName" placeholder="用户名" />
															<i class="ace-icon fa fa-user"></i>
														</span>
                                                </label>

                                                <label class="block clearfix">
														<span class="block input-icon input-icon-right">
															<input type="password" class="form-control" v-model="user.password" placeholder="密码" />
															<i class="ace-icon fa fa-lock"></i>
														</span>
                                                </label>

                                                <div class="space"></div>

                                                <div class="clearfix">
                                                    <label class="inline">
                                                        <input type="checkbox" v-model="remember" class="ace" />
                                                        <span class="lbl"> 记住我</span>
                                                    </label>

                                                    <button type="button" class="width-35 pull-right btn btn-sm btn-primary"
                                                    v-on:click="login()">
                                                        <i class="ace-icon fa fa-key"></i>
                                                        <span class="bigger-110">登录</span>
                                                    </button>
                                                </div>

                                                <div class="space-4"></div>
                                            </fieldset>
                                        </form>

                                    </div><!-- /.widget-main -->
                                </div><!-- /.widget-body -->
                            </div><!-- /.login-box -->


                        </div><!-- /.position-relative -->

                    </div>
                </div><!-- /.col -->
            </div><!-- /.row -->
        </div><!-- /.main-content -->
    </div><!-- /.main-container -->
</template>

<script>
    export default {
        name: "login",
        data:function(){
            return{
                user:{},
                remember:true
            }
        },
        mounted() {
            let _this = this;
            $('body').removeClass('no-skin');
            $('body').attr('class', 'login-layout light-login');

            //从缓存中获取记住的用户名密码，如果获取不到，说明上一次没有勾选"记住我"
            let rememberUser = LocalStorage.get(LOCAL_KEY_REMEMBER_USER);
            if(rememberUser){
                _this.user = rememberUser;
            }
        },
        methods:{
            login(){
                let _this = this;
                let passwordShow = _this.user.password;
                _this.user.password = hex_md5(_this.user.password + KEY);
                Loading.show();
                _this.$ajax.post(process.env.VUE_APP_SERVER +  '/system/admin/user/login', _this.user
                ).then((response)=>{
                    Loading.hide();
                    let resp = response.data;
                    if(resp.success){
                        console.log("登录成功",resp.content);
                        let loginUser = resp.content;

                        //判断"记住我"
                        if(_this.remember){
                            //如果勾选记住我，则将用户名密码保存至本地缓存，这里需要保存密码明文，否则登录时还会再加一次密
                            LocalStorage.set(LOCAL_KEY_REMEMBER_USER,{
                                loginName:loginUser.loginName,
                                password:passwordShow
                            });
                        }else{
                            //如果没有勾选记住我，要把本地缓存清空，否则按照mounted的逻辑，下次打开会自动显示用户名和密码
                            LocalStorage.set('LoginUser',null);
                        }
                        Tool.setLoginUser(resp.content);
                        this.$router.push("/welcome");//跳转到一个地址
                    }else{
                        Toast.warning(resp.message);
                    }
                })
            }
        }
    }
</script>




