<%-- 
    Document   : movements
    Created on : 26 de jul. de 2023, 21:27:55
    Author     : Guilherme
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
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
                    <h2>Movimentações</h2>
                    <%
                if(session.getAttribute("user")!=null){
                    User u = (User) session.getAttribute("user");
                    if(u.getRole().equals("ADMIN")){  
                    %>
                    <div class="input-group mb-3">
                        <input type="text" class="form-control" v-model="newName" placeholder="Nome do Cliente">
                        <input type="text" class="form-control" v-model="newNumber" placeholder="Número do Contêiner">
                        <select class="form-select" v-model="newMType">
                            <option value="" disabled selected hidden>Tipo de Movimentação</option>
                            <option value="Embarque">Embarque</option>
                            <option value="Descarga">Descarga</option>
                            <option value="Gate In">Gate In</option>
                            <option value="Gate Out">Gate Out</option>
                            <option value="Reposicionamento">Reposicionamento</option>
                            <option value="Pesagem">Pesagem</option>
                            <option value="Scanner">Scanner</option>
                        </select>
                        <button class="btn btn-primary" type="button" @click="addMovement">Adicionar</button>
                    </div>
                    <%}}%>
                    <table class="table">
                        <tr>
                            <th>Nome do Cliente</th>
                            <th>Número do Contêiner</th>
                            <th>Tipo de Movimentação</th>
                            <th>Data de Início</th>
                        </tr>
                        <tr v-for="item in list" :key="item.rowId">
                            <td>{{item.clientName}}</td>
                            <td>{{item.contNumber}}</td>
                            <td>{{item.moveType}}</td>
                            <td>{{item.beginMove}}</td>
                            <td>
                                <button class="btn btn-danger btn-sm" type="button" @click="endMovement(item.rowId)">Finalizar</button>
                            </td>
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
                        newName: '',
                        newNumber: '',
                        newMType: '',
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
                        const data = await this.request("/ContainersWebApp/api/movement", "GET");
                        if(data) {
                            this.list = data.list;
                        }
                    },
                    async addMovement() {
                        const data = await this.request("/ContainersWebApp/api/movement", "POST", {name: this.newName, number: this.newNumber, mtype:this.newMType});
                        if(data) {
                            this.newName = '';
                            this.newNumber = '';
                            this.newMType = '';
                            await this.loadList();
                        }
                    },
                    async endMovement(rowid) {
                        const data = await this.request("/ContainersWebApp/api/movement", "PUT", {id: rowid});
                        if(data) {
                            await this.loadList();
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
