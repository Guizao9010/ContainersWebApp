<%-- 
    Document   : history
    Created on : 24 de jul. de 2023, 14:26:53
    Author     : Guilherme
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Containers Web App</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9" crossorigin="anonymous">
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/header.jspf" %>
        <div id="app" class="container-fluid m-2">
            <div v-if="shared.session">
                <div v-if="error" class="alert alert-danger m-2" role="alert">
                    {{error}}
                </div>
                <div v-else>
                    <h2>Histórico</h2>
                    <table class="table">
                        <tr>
                            <th>Nome do Cliente</th>
                            <th>Número do Contêiner</th>
                            <th>Tipo de Movimentação</th>
                            <th>Data de Início</th>
                            <th>Data de Fim</th>
                        </tr>
                        <tr v-for="item in list" :key="item.rowId">
                            <td>{{item.clientName}}</td>
                            <td>{{item.contNumber}}</td>
                            <td>{{item.moveType}}</td>
                            <td>{{item.beginMove}}</td>
                            <td>{{item.endMove}}</td>
                        </tr>
                    </table>
                </div>
                    
            </div>
                
        </div>
        
        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        shared: shared,
                        error: null,
                        list: [],
                    }
                },
                methods: {
                    async request(url = "", method, data) {
                        try{
                            const response = await fetch(url, {
                                method: method,
                                headers: {"Content-Type": "application/json"},
                                body: JSON.stringify(data)
                            });
                            if(response.status==200){
                                return response.json();
                            }else{
                                this.error = response.statusText;
                            }
                        } catch(e){
                            this.error = e;
                            return null;
                        }
                    },
                    async loadList() {
                        const data = await this.request("/ContainersWebApp/api/movement?history", "GET");
                        if(data) {
                            this.list = data.list;
                        }
                    },
                },
                mounted() {
                    this.loadList();
                }
            });
            app.mount('#app');
        </script>
      <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm" crossorigin="anonymous"></script>
    </body>
</html>
