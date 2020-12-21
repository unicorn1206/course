<template>
    <div>
        <p>
            <button v-on:click="list(1)" class="btn btn-white btn-default btn-round">
                <i class="ace-icon fa fa-refresh"></i>
                刷新
            </button>
        </p>

        <!--ref属性：组件别名,v-bind,绑定一个方法，左边list为子组件内部定义，暴露给外部的一个回调方法
        ，右边list是当前组件的list方法，作用：点击按钮的时候要执行什么方法-->
<!--        <pagination ref="pagination" v-bind:list="list"></pagination>-->
        <pagination ref="pagination" v-bind:list="list" v-bind:itemCount="6"></pagination>


        <table id="simple-table" class="table  table-bordered table-hover">
                    <thead>
                    <tr>
                            <th>id</th>
                            <th>手机号</th>
                            <th>密码</th>
                            <th>昵称</th>
                            <th>头像url</th>
                            <th>注册时间</th>
                    </tr>
                    </thead>

                    <tbody>
                    <tr v-for="member in members" v-bind:key="member.id">
                        <td>{{member.id}}</td>
                        <td>{{member.mobile}}</td>
                        <td>{{member.password}}</td>
                        <td>{{member.name}}</td>
                        <td>{{member.photo}}</td>
                        <td>{{member.registerTime}}</td>

                    </tr>
                    </tbody>
                </table>
    </div>
</template>

<script>
    import Pagination from '../../components/pagination'//引入子组件2-1
    export default {
        components:{Pagination},//引入子组件2-2
        name: "business-member",
        data:function(){
            return{
                member:{},//新增时，弹出框的值
                // courseId:"",
                // name:'',
                members:[],//列表展示
            }
        },
        mounted:function () {
            //this.$parent.activeSideBar("business-member-sidebar");
            let _this = this;
            _this.$refs.pagination.size=5;
            _this.list(1);
        },
        methods:{

            /**
             * 列表查询
             */
            list(page){
                let _this = this;
                Loading.show();
                _this.$ajax.post(process.env.VUE_APP_SERVER +  '/business/admin/member/list',{
                    page:page,
                    size:_this.$refs.pagination.size//获取组件内部的size变量
                }).then((response)=>{
                    Loading.hide();
                    let resp = response.data;
                    _this.members = resp.content.list;
                    _this.$refs.pagination.render(page,resp.content.total);//重新渲染当前组件，所选页数的底色
                })
            }


  }
}
</script>

