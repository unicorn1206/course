<template>
    <div>
        <p>
            <button v-on:click="list(1)" class="btn btn-white btn-default btn-round">
                <i class="ace-icon fa fa-refresh"></i>
                刷新
            </button>
        </p>
        <div class="row">
            <div class="col-md-6">
                <textarea id="resource-textarea" class="form-control" v-model="resourceStr"
                          name="resource" rows="10"></textarea><br>
                <button v-on:click="save()" id="save-btn" type="button" class="btn btn-primary">
                    保存
                </button>
            </div>
            <div class="col-md-6">
                <ul id="tree" class="ztree"></ul>
            </div>
        </div><br>

    </div>
</template>

<script>
    export default {
        name: "system-resource",
        data:function(){
            return{
                resource:{},//新增时，弹出框的值
                // courseId:"",
                // name:'',
                resources:[],//列表展示
                resourceStr:'',
                tree:{}
            }
        },
        mounted:function () {
            //this.$parent.activeSideBar("system-resource-sidebar");
            let _this = this;
            _this.list();
        },
        methods:{
            initTree() {
                let _this = this;
                let setting = {
                    data: {
                        simpleData: {
                            idKey: "id",
                            pIdKey: "parent",
                            rootPId: ""
                        }
                    }
                };

                let zNodes = _this.resources;
                _this.tree = $.fn.zTree.init($("#tree"), setting, zNodes);
                _this.tree.expandAll(true);
            },
            /**
             * 列表查询
             */
            list(){
                let _this = this;
                Loading.show();
                _this.$ajax.get(process.env.VUE_APP_SERVER +  '/system/admin/resource/load-tree').then((response)=>{
                    Loading.hide();
                    let resp = response.data;
                    _this.resources = resp.content;
                    //初始化树
                    _this.initTree();
                })
            },

            /**
             * 点击【保存】
             */
            save(){
                let _this = this;
                // let resource ={
                //     couseId:this.courseId,
                //     name:this.name
                // }
                // 保存校验
                if(Tool.isEmpty(_this.resourceStr)){
                    Toast.warning("资源不能为空！");
                    return;
                }

                let json = JSON.parse(_this.resourceStr);
          Loading.show();
          _this.$ajax.post(process.env.VUE_APP_SERVER +  '/system/admin/resource/save',json
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
          Confirm.show("删除资源后不可恢复，确认删除？",function () {
              Loading.show();
              _this.$ajax.delete(process.env.VUE_APP_SERVER +  '/system/admin/resource/delete/' + id
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

