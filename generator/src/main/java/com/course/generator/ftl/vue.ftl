<template>
    <div>
        <p>
            <button v-on:click="add()" class="btn btn-white btn-default btn-round">
                <i class="ace-icon fa fa-edit"></i>
                新增
            </button>
            &nbsp;
            <button v-on:click="list(1)" class="btn btn-white btn-default btn-round">
                <i class="ace-icon fa fa-refresh"></i>
                刷新
            </button>
        </p>

        <!--ref属性：组件别名,v-bind,绑定一个方法，左边list为子组件内部定义，暴露给外部的一个回调方法
        ，右边list是当前组件的list方法，作用：点击按钮的时候要执行什么方法-->
<!--        <pagination ref="pagination" v-bind:list="list"></pagination>-->
        <pagination ref="pagination" v-bind:list="list" v-bind:itemCount="6"></pagination>

        <div id="form-modal" class="modal fade" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">表单</h4>
                    </div>
                    <div class="modal-body">
                        <form class="form-horizontal">
                            <div class="form-group">
                                <#list fieldList as field>
                                    <#if field.nameHump != 'createAt' && field.nameHump != 'updateAt'>
                                    <label  class="col-sm-2 control-label">${field.nameCn}</label>
                                    <div class="col-sm-10">
                                        <input  v-model="${domain}.${field.nameHump}" class="form-control">
                                    </div></#if>
                                </#list>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                        <button type="button" class="btn btn-primary" v-on:click="save()">保存</button>
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div><!-- /.modal -->

        <table id="simple-table" class="table  table-bordered table-hover">
                    <thead>
                    <tr><#list fieldList as field>
                            <#if field.nameHump != 'createAt' && field.nameHump != 'updateAt'>
                            <th>${field.nameCn}</th></#if></#list>
                        <th>操作</th>
                    </tr>
                    </thead>

                    <tbody>
                    <tr v-for="${domain} in ${domain}s" v-bind:key="${domain}.id">
                        <#list fieldList as field>
                            <#if field.nameHump != 'createAt' && field.nameHump != 'updateAt'>
                            <td>{{${domain}.${field.nameHump}}}</td></#if>
                        </#list>
                        <td>
                            <div class="hidden-sm hidden-xs btn-group">

                                <button v-on:click="edit(${domain})" class="btn btn-xs btn-info">
                                    <i class="ace-icon fa fa-pencil bigger-120"></i>
                                </button>

                                <button v-on:click="del(${domain}.id)" class="btn btn-xs btn-danger">
                                    <i class="ace-icon fa fa-trash-o bigger-120"></i>
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
        name: "${domain}",
        data:function(){
            return{
                ${domain}:{},//新增时，弹出框的值
                // courseId:"",
                // name:'',
                ${domain}s:[]//列表展示
            }
        },
        mounted:function () {
            //this.$parent.activeSideBar("${module}-${domain}-sidebar");
            let _this = this;
            _this.$refs.pagination.size=5;
            _this.list(1);
        },
        methods:{
            /**
             * 点击【新增】
             */
            add(){
                let _this = this;
                _this.${domain} = {};
                $('#form-modal').modal('show');
            },
            /**
             * 点击【编辑】
             */
            edit(${domain}){
                let _this = this;
                //数据双向绑定
                // _this.${domain} = ${domain};
                //取消数据双向绑定，在编辑框输入值，不影响列表内的值
                _this.${domain} = $.extend({},${domain});//将${domain}对象复制到一个空对象{}
                $('#form-modal').modal('show');
            },

            /**
             * 列表查询
             */
            list(page){
                let _this = this;
                Loading.show();
                _this.$ajax.post(process.env.VUE_APP_SERVER +  '/${module}/admin/${domain}/list',{
                    page:page,
                    size:_this.$refs.pagination.size//获取组件内部的size变量
                }).then((response)=>{
                    Loading.hide();
                    let resp = response.data;
                    _this.${domain}s = resp.content.list;
                    _this.$refs.pagination.render(page,resp.content.total);//重新渲染当前组件，所选页数的底色
                })
            },

            /**
             * 点击【保存】
             */
            save(){
                let _this = this;
                // let ${domain} ={
                //     couseId:this.courseId,
                //     name:this.name
                // }
                // 保存校验
                if (1 != 1
                    <#list fieldList as field>
                    <#if field.name!="id" && field.nameHump!="createdAt" && field.nameHump!="updatedAt" && field.nameHump!="sort">
                    <#if !field.nullAble>
                    || !Validator.require(_this.${domain}.${field.nameHump}, "${field.nameCn}")
                    </#if>
                    <#if (field.length > 0)>
                    || !Validator.length(_this.${domain}.${field.nameHump}, "${field.nameCn}", 1, ${field.length?c})
                    </#if>
                    </#if>
                    </#list>
                ) {
                    return;
                }
          Loading.show();
          _this.$ajax.post(process.env.VUE_APP_SERVER +  '/${module}/admin/${domain}/save', _this.${domain}
          ).then((response)=>{
              Loading.hide();
              let resp = response.data;
              if(resp.success){
                  $('#form-modal').modal('hide');
                  _this.list(1);
                  Toast.success('保存成功');
              }else{
                  Toast.warning(resp.message);
              }

          })
      },
      /**
       * 点击【删除】
       */
      del(id){
          let _this = this;
          Confirm.show("删除${tableNameCn}后不可恢复，确认删除？",function () {
              Loading.show();
              _this.$ajax.delete(process.env.VUE_APP_SERVER +  '/${module}/admin/${domain}/delete/' + id
              ).then((response)=>{
                  Loading.hide();
                  let resp = response.data;
                  if(resp.success){
                      _this.list(1);
                      Toast.success('删除成功');
                  }
              })
          });

      }
  }
}
</script>
