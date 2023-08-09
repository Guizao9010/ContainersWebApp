<%-- 
    Document   : index
    Created on : 26 de jul. de 2023, 12:04:00
    Author     : Guilherme
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<!DOCTYPE html>
<!doctype html>
<html lang="pt-br">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
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
            <h2>Contêineres</h2>
            <%
                if(session.getAttribute("user")!=null){
                    User u = (User) session.getAttribute("user");
                    if(u.getRole().equals("ADMIN")){  
                    %>
            <div class="input-group mb-3">
                        <input type="text" class="form-control" v-model="newName" placeholder="Nome do Cliente">
                        <input type="text" class="form-control" v-model="newNumber" placeholder="Número do Contêiner">
                        <select class="form-select" v-model="newType">
                            <option value="" disabled selected hidden>Tipo</option>
                            <option value="20">20</option>
                            <option value="40">40</option>
                        </select>
                        <select class="form-select" v-model="newStatus">
                            <option value="" disabled selected hidden>Status</option>
                            <option value="Cheio">Cheio</option>
                            <option value="Vazio">Vazio</option>
                        </select>
                       <select class="form-select" v-model="newCat">
                            <option value="" disabled selected hidden>Categoria</option>
                            <option value="Importacao">Importação</option>
                            <option value="Exportacao">Exportação</option>
                        </select>
                        <button class="btn btn-primary" type="button" @click="addContainer">Adicionar</button>
            </div>
            <%}}%>
            <table class="table">
                <tr>
                    <th>Nome do Cliente</th>
                    <th>Número do Conteiner</th>
                    <th>Tipo</th>
                    <th>Status</th>
                    <th>Categoria</th>
                </tr>
                <tr v-for="item in list" :key="item.rowId">
                            <td>{{ item.client }}</td>
                            <td>{{ item.contNumber }}</td>
                            <td>{{ item.type }}</td>
                            <td>{{ item.status }}</td>
                            <td>{{ item.category }}</td>
                            <td>
                                <button type="button" @click="deleteContainer(item.rowId)" class="btn btn-danger btn-sm">Apagar</button>
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
                        newType: '',
                        newStatus: '',
                        newCat: '',
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
                        const data = await this.request("/ContainersWebApp/api/container", "GET");
                        if(data) {
                            this.list = data.list;
                        }
                    },
                    async addContainer() {
                        const data = await this.request("/ContainersWebApp/api/container", "POST", {name: this.newName, number: this.newNumber, type: this.newType, status: this.newStatus, cat: this.newCat});
                        if(data) {
                            this.newName = ''; 
                            this.newNumber = ''; 
                            this.newType = '';
                            this.newStatus = '';
                            this.newCat = '';
                            await this.loadList();
                        }
                    },
                    async deleteContainer(id) {
                        const data = await this.request("/ContainersWebApp/api/container?id="+id, "DELETE");
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
