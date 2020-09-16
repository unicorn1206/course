<template>
    <div>
        <p>&nbsp;
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
                            <th>相对路径</th>
                            <th>文件名</th>
                            <th>后缀</th>
                            <th>大小</th>
                            <th>用途</th>
                    </tr>
                    </thead>

                    <tbody>
                    <tr v-for="file in files" v-bind:key="file.id">
                        <td>{{file.id}}</td>
                        <td>{{file.path}}</td>
                        <td>{{file.name}}</td>
                        <td>{{file.suffix}}</td>
                        <td>{{file.size}}</td>
                        <td>{{FILE_USE | optionKV(file.use)}}</td>
                    </tr>
                    </tbody>
                </table>
    </div>
</template>

<script>
    import Pagination from '../../components/pagination'//引入子组件2-1
    export default {
        components:{Pagination},//引入子组件2-2
        name: "file-file",
        data:function(){
            return{
                file:{},//新增时，弹出框的值
                // courseId:"",
                // name:'',
                files:[],//列表展示
                FILE_USE: FILE_USE,
            }
        },
        mounted:function () {
            //this.$parent.activeSideBar("file-file-sidebar");
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
                _this.$ajax.post(process.env.VUE_APP_SERVER +  '/file/admin/file/list',{
                    page:page,
                    size:_this.$refs.pagination.size//获取组件内部的size变量
                }).then((response)=>{
                    Loading.hide();
                    let resp = response.data;
                    _this.files = resp.content.list;
                    _this.$refs.pagination.render(page,resp.content.total);//重新渲染当前组件，所选页数的底色
                })
            }



  }
}
</script>

