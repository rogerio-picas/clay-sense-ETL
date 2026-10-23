# ClaySense ETL

**Sistema de Monitorização e Integração de Dados para a Indústria Cerâmica**

O projeto ClaySense é uma arquitetura *end-to-end* de integração de dados desenvolvida para modernizar o controlo operacional na indústria cerâmica. O sistema capta dados de sensores IoT (emulados), processa-os cruzando com custos de energia em tempo real, guarda a informação de forma estruturada e disponibiliza *dashboards* analíticos.

## - Tecnologias Utilizadas -

* **Node-RED:** Emulação de sensores IoT e envio de telemetria (MQTT).

* **Pentaho Data Integration (Kettle):** Pipeline de ETL, validação de regras de negócio e envio de alertas (Email).

* **PostgreSQL (NeonDB):** Base de dados relacional na *cloud*.

* **Grafana:** Visualização de dados e inteligência de negócio.

## - Estrutura do Projeto -

* `/kettle/` - Contém o Main Job e todas as transformações (Data Preparation, Production Model, etc.).

* `/node-red/` - Ficheiro `.json` com a exportação do fluxo IoT.

* `/sql/` - Contém o ficheiro `schema.sql` com a estrutura DDL da base de dados.

* `/grafana/` - Ficheiros `.json` para importação dos *dashboards*.

* `/data/` - Ficheiros `kiln_telemetry.json, production.csv e energy_tariffs.xml` que serão utilizados como input .

* `/reports/` - Pasta de destino para os relatórios gerados (Excel).

* `/doc/` - Relatório da implementação do sistema em formato pdf.

* `/logs/` - Pasta de armazenamento de ficheiros de logs do sistema.

* `/archive/` - Pasta de armazenamento dos ficheiros de dados(CSV, JSON, XML) já processados.

## - Pré-requisitos e Preparação do Ambiente -

Para executar este projeto localmente, a máquina deve ter o seguinte software instalado:

1. **Java Runtime Environment (JRE 8 ou 11):** Necessário para correr o Pentaho.

2. **Pentaho Data Integration (PDI):** Descarregar e extrair o PDI (Kettle).

3. **Node.js e Node-RED:** Para correr o emulador de sensores.

4. **DBeaver (Opcional):** Para consultar a base de dados.

5. **Broker MQTT (Eclipse Mosquitto)**

   * **Função:** Intermediar as mensagens geradas pelo Node-RED para a infraestrutura de dados.

   * **Instalação:** Acede a `mosquitto.org/download`, descarrega o instalador correspondente ao teu sistema operativo e avança com as opções predefinidas (garantindo que é instalado como serviço).

   * **Verificação:** Após a instalação, abre a linha de comandos ou o PowerShell e executa o comando `mosquitto -v` para confirmar que o serviço está ativo a escutar no porto padrão 1883.

## - Guia de Configuração e Execução -

### Passo 1: Base de Dados (NeonDB / PostgreSQL)

1. Crie uma base de dados PostgreSQL.

2. Execute o script `sql/schema.sql` na sua base de dados para criar as tabelas `kiln`, `production`, `kiln_firing`, etc.

3. Copiar a *Connection String*.

### Passo 2: Configuração do Pentaho (ETL)

1. Inicie o Pentaho executando o ficheiro `spoon.bat` (Windows) ou `spoon.sh` (Linux/Mac.

2. Abra o ficheiro correspondente ao **Main Job**.

3. **Atenção aos Caminhos:** Em todas as transformações que leem ou guardam ficheiros (ex: relatórios Excel na pasta `sent_reports`), atualize os caminhos (`File/Directory`) para corresponderem às pastas locais da sua máquina. Para um funcionamento sem problemas,  o Pentaho recomenda utilizar paths absolutos.

4. Nas ligações à base de dados dentro do Pentaho, atualize as credenciais (Host, User, Password) para as da base de dados configurada no Passo 1.

### Passo 3: Ativação dos Sensores (Node-RED)

1. Abra o terminal e inicie o Node-RED executando o comando: `node-red`.

2. Aceda ao interface no browser (normalmente `http://localhost:1880`).

3. Vá ao menu superior direito > **Import** e carregue o ficheiro `.json` que se encontra na pasta `/node-red/nodered-flows.json`.

4. Clique em **Deploy** para iniciar a simulação e o envio de dados via MQTT.

### Passo 4: Execução do Fluxo

1. Com o Node-RED a gerar dados, volte ao Pentaho.

2. No separador do **Main Job**, clique no botão **Run** (Play).

3. Verifique os vistos verdes nos *steps*. O sistema irá processar os dados, inserir na base de dados, gerar o relatório de custos (Excel) e movê-lo para a pasta `/sent_reports/`.

### Passo 5: Visualização (Grafana)

1. Aceda à sua instância do Grafana.

2. Vá a **Connections > Data Sources** e adicione o PostgreSQL (com os dados do Passo 1).

3. Vá a **Dashboards > Import** e carregue os ficheiros `.json` da pasta `/grafana/`.

## - Demonstração -

Para uma visão rápida do sistema em funcionamento, consulte o código QR disponível no Capítulo 6 do relatório do projeto, que reencaminha para a gravação em vídeo da execução do pipeline e do funcionamento sequencial de todos os jobs e transformations.