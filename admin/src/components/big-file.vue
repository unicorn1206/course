<template>
    <div>
        <button type="button" v-on:click="selectFile()" class="btn btn-white btn-default btn-round">
            <i class="ace-icon fa fa-upload"></i>
            {{text}}
        </button>
        <input class="hidden" type="file" ref="file" v-on:change="uploadFile()" v-bind:id="inputId + '-input'">

    </div>
</template>

<script>
  export default {
    name: 'file',
      //props：定义父组件向子组件传递的参数，可以是一个函数或数据
    props: {
        text:{
            default:"上传文件"
        },
        afterUpload: {
            type: Function,
            default: null
        },
        inputId:{
            default:"file-upload"
        },
        suffixs:{
            default:[]
        },
        use:{
            default:""
        }
    },
    data: function () {
      return {
      }
    },
    methods: {
        /**
         * 上传头像
         */
        uploadFile() {
            let _this = this;
            let formData = new window.FormData();
            let file = _this.$refs.file.files[0];
            let fileName = file.name;
            console.log(file);

            //生成文件标识，标识多次上传的是不是同一个文件
            let key = hex_md5(file);
            let key10 = parseInt(key,16);
            let key62 = Tool._10to62(key10);
            console.log(key,key10,key62);

            //判断文件格式
            let suffixs = _this.suffixs;
            let suffix = fileName.substring(fileName.lastIndexOf(".") + 1,fileName.length).toLowerCase();
            let validateSuffix = false;
            for(let i in suffixs){
                if(suffixs[i].toLowerCase() === suffix){
                    validateSuffix = true;
                    break;
                }
            }
            if(!validateSuffix){
                Toast.warning("文件格式不正确，只支持上传：" + suffixs.join(","));
                $('#' + _this.inputId + '-input').val("");
                return;
            }
            //文件分片
            let shardSize = 20 * 1024 * 1024; //以20MB为一个分片
            let shardIndex = 1; //分片索引,1表示第一个分片
            let start = (shardIndex - 1) * shardSize; //当前分片起始位置
            let end = Math.min(file.size,start + shareSize); //当前分片结束位置
            let fileshard = file.slice(start,end); //从文件中截取当前的分片数据

            let size = file.size;
            let shardTotal = Math.ceil(size / shardSize);//总片数

            //key:file必须和后端controller参数名一致
            formData.append('shard',fileshard);
            formData.append('shardIndex',shardIndex);
            formData.append('shardSize',shardSize);
            formData.append('shardTotal',shardTotal);
            formData.append('use',_this.use);
            formData.append('name',file.name);
            formData.append('suffix',suffix);
            formData.append('size',size);
            formData.append('key',key62);
            Loading.show();
            _this.$ajax.post(process.env.VUE_APP_SERVER + '/file/admin/upload/',formData
            ).then((response) => {
                Loading.hide();
                let resp = response.data;
                _this.afterUpload(resp);
                console.log("上传文件成功",resp);
                $('#' + _this.inputId + '-input').val("");
            });
        },
        /**
         * 上传头像组件
         */
        selectFile(){
            let _this = this;
            $('#' + _this.inputId + '-input').trigger("click");
        }
    }
  }
</script>


