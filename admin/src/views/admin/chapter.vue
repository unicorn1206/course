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
                        <th>ID</th>
                        <th>名称</th>
                        <th>课程</th>
                        <th>操作</th>
                    </tr>
                    </thead>

                    <tbody>
                    <tr v-for="chapter in chapters" v-bind:key="chapter.id">
                        <td>{{chapter.id}}</td>
                        <td>{{chapter.courseId}}</td>
                        <td>{{chapter.name}}</td>

                        <td>
                            <div class="hidden-sm hidden-xs btn-group">
                                <button class="btn btn-xs btn-success">
                                    <i class="ace-icon fa fa-check bigger-120"></i>
                                </button>

                                <button class="btn btn-xs btn-info">
                                    <i class="ace-icon fa fa-pencil bigger-120"></i>
                                </button>

                                <button class="btn btn-xs btn-danger">
                                    <i class="ace-icon fa fa-trash-o bigger-120"></i>
                                </button>

                                <button class="btn btn-xs btn-warning">
                                    <i class="ace-icon fa fa-flag bigger-120"></i>
                                </button>
                            </div>

                            <div class="hidden-md hidden-lg">
                                <div class="inline pos-rel">
                                    <button class="btn btn-minier btn-primary dropdown-toggle" data-toggle="dropdown" data-position="auto">
                                        <i class="ace-icon fa fa-cog icon-only bigger-110"></i>
                                    </button>

                                    <ul class="dropdown-menu dropdown-only-icon dropdown-yellow dropdown-menu-right dropdown-caret dropdown-close">
                                        <li>
                                            <a href="#" class="tooltip-info" data-rel="tooltip" title="View">
                                                                                <span class="blue">
                                                                                    <i class="ace-icon fa fa-search-plus bigger-120"></i>
                                                                                </span>
                                            </a>
                                        </li>

                                        <li>
                                            <a href="#" class="tooltip-success" data-rel="tooltip" title="Edit">
                                                                                <span class="green">
                                                                                    <i class="ace-icon fa fa-pencil-square-o bigger-120"></i>
                                                                                </span>
                                            </a>
                                        </li>

                                        <li>
                                            <a href="#" class="tooltip-error" data-rel="tooltip" title="Delete">
                                                                                <span class="red">
                                                                                    <i class="ace-icon fa fa-trash-o bigger-120"></i>
                                                                                </span>
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </td>
                    </tr>
                    </tbody>
                </table>
    </div>
</template>

<script>
    import Pagination from '../../components/pagination'//引入子组件2-1
    export default {
        components:{Pagination},//引入子组件2-2
        name: "chapter",
        data:function(){
            return{
                chapters:[]
            }
        },
        mounted:function () {
            //this.$parent.activeSideBar("business-chapter-sidebar");
            let _this = this;
            _this.$refs.pagination.size=5;
            _this.list(1);
        },
        methods:{
            list(page){
                let _this = this;
                _this.$ajax.post('http://127.0.0.1:9000/business/admin/chapter/list',{
                    page:page,
                    size:_this.$refs.pagination.size//获取组件内部的size变量
                }).then((response)=>{
                    console.log(response);
                    _this.chapters = response.data.list;
                    _this.$refs.pagination.render(page,response.data.total);//重新渲染当前组件，所选页数的底色
                })
            }
        }
    }
</script>

