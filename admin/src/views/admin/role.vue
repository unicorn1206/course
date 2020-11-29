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
                                <label class="col-sm-2 control-label">角色</label>
                                <div class="col-sm-10">
                                    <input v-model="role.name" class="form-control">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">描述</label>
                                <div class="col-sm-10">
                                    <input v-model="role.desc" class="form-control">
                                </div>
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

        <!--角色资源关联配置-->
        <div id="resource-modal" class="modal fade" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">角色资源关联配置</h4>
                    </div>
                    <div class="modal-body">
                        <form class="form-horizontal">
                            <ul id="tree" class="ztree"></ul>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                        <button type="button" class="btn btn-primary" v-on:click="saveResource()">保存</button>
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div><!-- /.modal -->

        <table id="simple-table" class="table  table-bordered table-hover">
                    <thead>
                    <tr>
                            <th>id</th>
                            <th>角色</th>
                            <th>描述</th>
                        <th>操作</th>
                    </tr>
                    </thead>

                    <tbody>
                    <tr v-for="role in roles" v-bind:key="role.id">
                        <td>{{role.id}}</td>
                        <td>{{role.name}}</td>
                        <td>{{role.desc}}</td>
                        <td>
                            <div class="hidden-sm hidden-xs btn-group">

                                <button v-on:click="editResource(role)" class="btn btn-xs btn-info">
                                    <i class="ace-icon fa fa-list bigger-120"></i>
                                </button>

                                <button v-on:click="edit(role)" class="btn btn-xs btn-info">
                                    <i class="ace-icon fa fa-pencil bigger-120"></i>
                                </button>

                                <button v-on:click="del(role.id)" class="btn btn-xs btn-danger">
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
        name: "system-role",
        data:function(){
            return{
                role:{},//新增时，弹出框的值
                // courseId:"",
                // name:'',
                roles:[],//列表展示
                resources:[],
                tree:{}
            }
        },
        mounted:function () {
            //this.$parent.activeSideBar("system-role-sidebar");
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
                _this.role = {};
                $('#form-modal').modal('show');
            },
            /**
             * 点击【编辑】
             */
            edit(role){
                let _this = this;
                //数据双向绑定
                // _this.role = role;
                //取消数据双向绑定，在编辑框输入值，不影响列表内的值
                _this.role = $.extend({},role);//将role对象复制到一个空对象{}
                $('#form-modal').modal('show');
            },

            /**
             * 点击【编辑角色资源】
             */
            editResource(role){
                let _this = this;
                _this.role = $.extend({},role);//将role对象复制到一个空对象{}
                _this.loadResource();
                $('#resource-modal').modal('show');
            },

            /**
             * 加载资源树
             */
            loadResource() {
                let _this = this;
                Loading.show();
                _this.$ajax.get(process.env.VUE_APP_SERVER + '/system/admin/resource/load-tree').then((response) => {
                    Loading.hide();
                    let resp = response.data;
                    _this.resources = resp.content;
                    //初始化树
                    _this.initTree();
                    _this.listRoleResource();
                })
            },

            /**
             * 初始化资源树
             */
            initTree(){
                let _this = this;
                let setting = {
                    check:{
                        enable:true
                    },
                    data: {
                        simpleData: {
                            idKey: "id",
                            pIdKey: "parent",
                            rootPId: "",
                            enable:true
                        }
                    }
                };

                let zNodes = _this.resources;
                _this.tree = $.fn.zTree.init($("#tree"), setting, zNodes);
                _this.tree.expandAll(true);
            },
            /**
             * 加载角色资源关联记录
             */
            listRoleResource(){
                let _this = this;
                Loading.show();
                _this.$ajax.get(process.env.VUE_APP_SERVER +  '/system/admin/role/list-resource/' + _this.role.id,).then((response)=>{
                    Loading.hide();
                    let resp = response.data;
                    let resources = resp.content;

                    //勾选查询到的资源，先把树的所有节点清空勾选，再勾选查询到的节点
                    _this.tree.checkAllNodes(false);
                    for(let i = 0;i < resources.length;i++){
                        let node = _this.tree.getNodeByParam("id",resources[i]);
                        _this.tree.checkNode(node,true);
                    }

                })
            },
            /**
             * 列表查询
             */
            list(page){
                let _this = this;
                Loading.show();
                _this.$ajax.post(process.env.VUE_APP_SERVER +  '/system/admin/role/list',{
                    page:page,
                    size:_this.$refs.pagination.size//获取组件内部的size变量
                }).then((response)=>{
                    Loading.hide();
                    let resp = response.data;
                    _this.roles = resp.content.list;
                    _this.$refs.pagination.render(page,resp.content.total);//重新渲染当前组件，所选页数的底色
                })
            },

            /**
             * 点击【保存】
             */
            save(){
                let _this = this;
                // let role ={
                //     couseId:this.courseId,
                //     name:this.name
                // }
                // 保存校验
                if (1 != 1
                    || !Validator.require(_this.role.name, "角色")
                    || !Validator.length(_this.role.name, "角色", 1, 50)
                    || !Validator.require(_this.role.desc, "描述")
                    || !Validator.length(_this.role.desc, "描述", 1, 100)
                ) {
                    return;
                }
          Loading.show();
          _this.$ajax.post(process.env.VUE_APP_SERVER +  '/system/admin/role/save', _this.role
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
          Confirm.show("删除角色后不可恢复，确认删除？",function () {
              Loading.show();
              _this.$ajax.delete(process.env.VUE_APP_SERVER +  '/system/admin/role/delete/' + id
              ).then((response)=>{
                  Loading.hide();
                  let resp = response.data;
                  if(resp.success){
                      _this.list(1);
                      Toast.success('删除成功');
                  }
              })
          });

      },
            /**
             * 资源模态框，点击【保存】
             */
            saveResource(){
                let _this = this;
                let resources = _this.tree.getCheckedNodes();
                console.log("勾选的资源：",resources);

                //保存时，只需保存资源id，所以使用id数组进行资源传递
                let resourceIds = [];
                for(let i = 0;i < resources.length;i++){
                    resourceIds.push(resources[i].id);
                }

                Loading.show();
                _this.$ajax.post(process.env.VUE_APP_SERVER +  '/system/admin/role/save-resource',
                    {
                        id:_this.role.id,
                        resourceIds:resourceIds
                    }
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
            }
  }
}
</script>

