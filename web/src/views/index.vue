<template>
    <main role="main">

        <section class="jumbotron text-center">
            <div class="container">
                <h1>web课程</h1>
                <p class="lead text-muted">Something short and leading about the collection below—its contents, the creator, etc. Make it short and sweet, but not too short so folks don’t simply skip over it entirely.</p>
                <p>
                    <a href="#" class="btn btn-primary my-2 p-3 font-weight-bold">点击进入课程</a>

                </p>
            </div>
        </section>

        <div class="album py-5 bg-light">
            <div class="container">

                <div class="row">
                    <div v-for="o in news" v-bind:key="o.name" class="col-md-4">
                        <div class="card mb-4 shadow-sm">
                            <img class="img-fluid" v-bind:src="o.image">
                            <div class="card-body">
                                <h4>{{o.name}}</h4>
                                <p class="card-text">{{o.summary}}</p>
                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="btn-group">
                                        <button type="button" class="btn btn-sm btn-outline-secondary">View</button>
                                        <button type="button" class="btn btn-sm btn-outline-secondary">Edit</button>
                                    </div>
                                    <div class="text-muted">
                                        <span class="badge badge-info"><i class="fa fa-yen" aria-hidden="true"></i>&nbsp;{{o.price}}</span>&nbsp;
                                        <span class="badge badge-info"><i class="fa fa-user" aria-hidden="true"></i>&nbsp;{{o.enroll}}</span>&nbsp;
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>

    </main>
</template>

<script>
    export default {
        name: "index",
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

</style>