# Implementação do schema plugin de GeoNetwork para o Perfil Nacional de Metadados de Informação Geográfica (MIG)

Implementação do schema plugin do GeoNework para o Perfil Nacional de Metadados de Informação Geográfica (MIG). Tendo como base o schema iso19139, implementa as regras de validação específicas do Perfil MIG e adiciona novos campos à indexação da informação dos metadados, de forma a permitir suportar as pesquisas que são disponibilizadas através do [Registo Nacional de Dados Geográficos](https://snig.dgterritorio.gov.pt/rndg/srv/por/catalog.search#/home).

Para mais informação, consultar:
- [Perfil Nacional de Metadados](https://snig.dgterritorio.gov.pt/docs/perfil-nacional-de-metadados-de-informacao-geografica-perfil-mig-v-20)
- [Documentação do GeoNetwork](https://docs.geonetwork-opensource.org/4.4/customizing-application/implementing-a-schema-plugin/)
- [Metadados 101](https://github.com/metadata101)

## Instalação do schema plugin

Os plugins são instalados na `geonetwork.dir`, onde estão também os uploads, ficheiros, etc, para se poder fazer um ou mais deploys do código sem reescrever a `geonetwork.dir`.

Convém sempre separar a `geonetwork.dir` do código. Num deploy sobre tomcat, por exemplo, a `geonetwork.dir` não deve estar debaixo de `/var/lib/tomcat9/webapps/geonetwork/`.

### Versão do GeoNetwork a utilizar com este plugin

Este schema plugin foi desenvolvido para o GeoNetwork 4.x.

Para utilizar o plugin em versões anteriores, use o [repositório para a versão 3.x](https://github.com/wktsi/iso19139.pt.mig.2.0), de onde deriva esta versão.

### Adicionar o schema plugin iso19139.pt.mig.2.0

Este plugin pode ser adicionado de duas maneiras:
- Pode ser adicionado a uma instalação do GeoNetwork existente
- Pode ser acrescentado às sources do Geonetwork

#### Adicionar o schema plugin iso19139.pt.mig.2.0 a uma instalação existente

Se compilou o plugin localmente, pode acrescentá-lo a uma ou mais instalações existentes (que corram a mesma versão do GeoNetwork usada para compilar o plugin).

Tem que:
- copiar o plugin para debaixo da pasta `geonetwork.dir`.
- copiar o `gn-schema-iso19139.pt.mig.2.0-4.4.7-0.jar` para a pasta `WEB-INF/lib/`.

Exemplo de deploy, em que `geonetwork.dir` é `/var/lib/geonetwork_data`, num deploy baseado em tomcat:

```bash
sudo su
cd /var/lib/geonetwork_data/config/schema_plugins
tar xvzf ~geomaster/iso19139.pt.mig.2.0.tgz
chown -R tomcat:tomcat iso19139.pt.mig.2.0
exit
sudo cp gn-schema-iso19139.pt.mig.2.0-4.4.7-0.jar /var/lib/tomcat9/webapps/geonetwork/WEB-INF/lib/
sudo chown tomcat:tomcat /var/lib/tomcat9/webapps/geonetwork/WEB-INF/lib/gn-schema-iso19139.pt.mig.2.0-4.4.7-0.jar
sudo systemctl restart tomcat9
```

#### Adicionar o schema plugin iso19139.pt.mig.2.0 às fontes do GeoNetwork

Para compilar o plugin, vai ter que o adicionar às fontes do GeoNetwork. Para as versões do GeoNetwork 4.x, recomenda-se a utilização da JAVA versão 11.

Nestas instruções vamos ser detalhados e explicar cada um dos passos, desde o início.

Vamos usar, nos exemplo, a versão 4.4.7. Por essa razão, depois do clonar o repositório, faz-se um `git checkout tags/4.4.7` para um novo branch local, onde vamos fazer as nossas alterações.

##### Obter as sources do GeoNetwork:

Obter o GeoNetwork, com os submódulos:
- Submodule path `'plugins/datahub-integration/geonetwork-ui'`
- Submodule path `'web-ui/src/main/resources/catalog/lib/bootstrap-table'`
- Submodule path `'web-ui/src/main/resources/catalog/lib/style/bootstrap'`
- Submodule path `'web-ui/src/main/resources/catalog/lib/style/font-awesome'`

```bash
git clone --recurse-submodules git@github.com:geonetwork/core-geonetwork.git
cd core-geonetwork/
git checkout tags/4.4.7 -b my_gn447_mig
mvn -U clean install -DskipTests
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
```

Se a compilação correu bem, pode-se prosseguir. Se houver algum problema, deve resolvê-lo antes de prosseguir. Reforça-se que deve compilar usando o JAVA 11.

##### Acrescentar o schema plugin iso19139.pt.mig.2.0

Acrescentar o schema plugin iso19139.pt.mig.2.0 passa também por acrescentar mais um submódulo git.

Primeira alternativa: Acrescentar o schema plugin iso19139.pt.mig.2.0 usando a script `./add-schema.sh`.

```bash
./add-schema.sh iso19139.pt.mig.2.0 https://github.com/jgrocha/iso19139.pt.mig.2.0 main
```

Embora seja a forma recomendada na documentação, a script `./add-schema.sh` está a precisar de ser atualizada. Use a segunda alternativa manual, sem script.

Segunda alternativa: acrescentar manualmente o plugin.

```bash
cd schemas
git submodule add -b main https://github.com/jgrocha/iso19139.pt.mig.2.0 iso19139.pt.mig.2.0
vi pom.xml
```
Adicionar o novo submódulo ao ficheiro `schemas/pom.xml`:
```xml
  <modules>
    <module>schema-core</module>
    ...
    <module>iso19139</module>
    <module>iso19115-3.2018</module>
    <module>iso19139.pt.mig.2.0</module>
  </modules>
```
Adicionar a dependência ao módulo `web/pom.xml`
```bash
cd ..
vi web/pom.xml
```
```xml
      <dependencies>
        <!-- add schema_plugins -->
        <dependency>
          <groupId>org.geonetwork-opensource.schemas</groupId>
          <artifactId>gn-schema-iso19139.pt.mig.2.0</artifactId>
          <version>${project.version}</version>
        </dependency>
      </dependencies>
```

#####  Compilar o plugin + GeoNetwork

```bash
cd schemas/iso19139.pt.mig.2.0
grep "<version>4" pom.xml
    <version>4.4.7-0</version>
-- se estiver a trabalhar sobre uma outra versão do GeoNetwork mais recente:
sed -i 's/<version>4.4.7-0<\/version>/<version>4.4.8-SNAPSHOT<\/version>/' pom.xml
-- build do plugin
mvn clean install
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------

cd ../..
mvn -U clean install -DskipTests -Penv-prod
...
[INFO] Perfil Nacional de Metadados de Informação Geográfica (MIG) 4.4.7-0 SUCCESS [  0.206 s]
...
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------

# Empacotar o plugin
cd schemas/iso19139.pt.mig.2.0/src/main/plugin/
tar cvzf ../../../../../iso19139.pt.mig.2.0.tgz iso19139.pt.mig.2.0
cd ../../../../..
```

A compilação gera três artefactos que devem ser usados para o deploy do GeoNetwork:
- `./iso19139.pt.mig.2.0.tgz`
- `./web/target/geonetwork.war`
- `./schemas/iso19139.pt.mig.2.0/target/gn-schema-iso19139.pt.mig.2.0-4.4.7-0.jar`

Os três artefactos podem ser publicados de acordo com o seguinte exemplo, em que `geonetwork.dir` é `/var/lib/geonetwork_data`.

```bash
-- trazer os artefactos para o servidor
wget https://braga.geomaster.pt/~jgr/geonetwork.war
wget https://braga.geomaster.pt/~jgr/iso19139.pt.mig.2.0.tgz
wget https://braga.geomaster.pt/~jgr/gn-schema-iso19139.pt.mig.2.0-4.4.7-0.jar
-- publicar
sudo cp geonetwork.war /var/lib/tomcat9/webapps/
sudo su
cd /var/lib/geonetwork_data/config/schema_plugins
tar xvzf ~geomaster/iso19139.pt.mig.2.0.tgz
chown -R tomcat:tomcat iso19139.pt.mig.2.0
exit
sudo cp gn-schema-iso19139.pt.mig.2.0-4.4.7-0.jar /var/lib/tomcat9/webapps/geonetwork/WEB-INF/lib/
sudo chown tomcat:tomcat /var/lib/tomcat9/webapps/geonetwork/WEB-INF/lib/gn-schema-iso19139.pt.mig.2.0-4.4.7-0.jar
sudo systemctl restart tomcat9
```