<template>
    <main role="main">
        <div class="album py-5 bg-light">
            <div class="container">
                <div class="row">
                    <div v-for="o in courses" v-bind:key="o.name" class="col-md-4">
                        <the-course v-bind:course="o"></the-course>
                    </div>
                    <h3 v-show="courses.length === 0">课程还未上架</h3>
                </div>
            </div>
        </div>

    </main>
</template>

<script>
    import TheCourse from "../components/the-course";
    export default {
        name: "index",
        components: {TheCourse},
        data:function () {
            return{
                courses:[]
            }
        },
        mounted() {
            let _this = this;
            _this.listCourse();
        },
        methods:{
            /**
             * 查找课程列表
             */
            listCourse(page){
                let _this = this;
                Loading.show();
                _this.$ajax.post(process.env.VUE_APP_SERVER + '/business/web/course/list', {
                    page: page,
                    size: 3
                }).then((response) => {
                    Loading.hide();
                    let resp = response.data;
                    _this.courses = resp.content.list;
                    //_this.$refs.pagination.render(page, resp.content.total);//重新渲染当前组件，所选页数的底色
                }).catch((response) => {
                    console.log("error:",response);
                })
            }
        }
    }
</script>

<style scoped>
    .title1{
        margin-bottom: 2rem;
        color: #fafafa;
        letter-spacing: 0;
        text-shadow: 0px 1px 0px #999,0px 2px 0px #888,0px 3px 0px #777,0px 4px 0px #666;
        font-size:2rem;
    }
    .title2{
        margin-bottom: 2rem;
        color: transparent;
        -webkit-text-stroke: 1px black;
        letter-spacing: 0.04em;
        font-size:2rem;
    }

</style>