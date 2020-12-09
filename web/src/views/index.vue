<template>
    <main role="main">

        <section class="jumbotron text-center">
            <div class="container">
                <h1>web课程</h1>
                <p class="lead text-muted">Something short and leading about the collection below—its contents, the creator, etc. Make it short and sweet, but not too short so folks don’t simply skip over it entirely.</p>
                <p>
                    <router-link to="/list" class="btn btn-primary my-2 p-3 font-weight-bold">点击进入课程</router-link>
                </p>
            </div>
        </section>

        <div class="album py-5 bg-light">
            <div class="container">
                <div class="title1">最新上线</div>
                <div class="row">
                    <div v-for="o in news" v-bind:key="o.name" class="col-md-4">
                        <the-course v-bind:course="o"></the-course>
                    </div>
                </div>
                <hr>
                <div class="title2">好课推荐</div>
                <div class="row">
                    <div v-for="o in news" v-bind:key="o.name" class="col-md-4">
                        <the-course v-bind:course="o"></the-course>
                    </div>
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
                news:[]
            }
        },
        mounted() {
            let _this = this;
            _this.listNew();
        },
        methods:{
            /**
             * 查找上新好课
             */
            listNew(){
                let _this = this;
                _this.$ajax.get(process.env.VUE_APP_SERVER +  '/business/web/course/list-new').then((response)=>{
                    console.log("查找上新好课:",response);
                    let resp = response.data;
                    if (resp.success){
                        _this.news = resp.content;
                    }
                }).catch((responce) => {
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