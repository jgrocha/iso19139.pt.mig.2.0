# Implementação do schema plugin de GeoNetwork para o Perfil Nacional de Metadados de Informação Geográfica (MIG)

Implementação do schema plugin do GeoNework para o Perfil Nacional de Metadados de Informação Geográfica (MIG). Tendo como base o schema iso19139, implementa as regras de validação específicas do Perfil MIG e adiciona novos campos à indexação da informação dos metadados, de forma a permitir suportar as pesquisas que são disponibilizadas através do Registo Nacional de Dados Geográficos.

## Instalação do schema plugin

### Versão do GeoNetwork a utilizar com este plugin

Este schema plugin foi desenvolvido para o GeoNetwork 3.4+, não se recomenda a sua utilização com outras versões.

### Adicionar o schema plugin ao código fonte

A versão adaptada do GeoNetwork para o SNIG (https://github.com/wktsi/core-geonetwork) adiciona automaticamente este schema plugin como um submódulo do projeto, pelo que apenas é necessário seguir as instruções de instalação dessa versão. No entanto, este schema plugin pode também ser utilizado na versão base GeoNetwork 3.4+, descrevendo-se em seguinte as passos a realizar para fazer a sua integração nessa versão: 
1. Mudar para a pasta *schemas*
```
$ cd core-geonetwork/schemas
```
2. Adicionar o schema plugin como um submódulo do módulo *schemas* 
```
git submodule add -b 3.4.x https://github.com/wktsi/iso19139.pt.mig.2.0.git iso19139.pt.mig.2.0
```
3. Adicionar o novo submódulo ao ficheiro pom.xml do módulo *schemas* (core-geonetwork/schemas/pom.xml):
```
<modules>
  ...
  <module>iso19139</module>
  **<module>iso19139.pt.mig.2.0</module>**
</modules>
```
4. Adicionar a dependência ao módulo *web* (core-geonetwork/web/pom.xml) 
Add the dependency in the web module in web/pom.xml:
```
<dependency>
  <groupId>${project.groupId}</groupId>
  <artifactId>schema-iso19139.pt.mig.2.0</artifactId>
  <version>${gn.schemas.version}</version>
</dependency>
```
5. Adicionar o módulo à *webapp* (core-geonetwork/web/pom.xml):
```
<execution>
  <id>copy-schemas</id>
  <phase>process-resources</phase>
  ...
  <resource>
    <directory>${project.basedir}/../schemas/iso19139.pt.mig.2.0/src/main/plugin</directory>
    <targetPath>${basedir}/src/main/webapp/WEB-INF/data/config/schema_plugins</targetPath>
  </resource>
```

### Fazer o *build* da aplicação

Como resultado do *build* da aplicação, é produzido o ficheiro **war** que contém o schema plugin (core-geonetwork/schemas/iso19139.pt.mig.2.0/target/schema-iso19139.pt.mig.2.0-3.4.jar):
1. Mudar para a pasta do schema plugin
```
$ cd core-geonetwork/schemas/iso19139.pt.mig.2.0
```
2. Fazer build 
```
$ mvn clean install -Penv-prod
```

### Instalar o schema plugin numa instalação existente do GeoNetwork

Depois de realizado o *build* da aplicação, é possível copiar o manualmente o schema plugin para uma instalação existente do GeoNework (recomenda-se que seja na versão 3.4+):

- Copiar o conteúdo conteúdo da pasta core-geonetwork/schemas/iso19139.pt.mig.2.0/src/main/plugin para GEONETWORK_DIR/WEB-INF/data/config/schema_plugins/iso19139.pt.mig.2.0
- Copiar o ficheiro **jar** core-geonetwork/schemas/iso19139.pt.mig.2.0/target/schema-iso19139.pt.mig.2.0-3.4.jar para GEONETWORK_DIR/WEB-INF/lib.
- Reiniciar o serviço
