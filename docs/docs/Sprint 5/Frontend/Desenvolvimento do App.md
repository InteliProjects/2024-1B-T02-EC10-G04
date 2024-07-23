---
title: Desenvolvimentos do APP
sidebar_position: 1
slug: frontend
---

# Desenvolvimento do Aplicativo 

O desenvolvimento do aplicativo está sendo conduzido com o uso do Flutter, um framework open-source criado pelo Google, que permite a criação de aplicativos nativos para iOS e Android utilizando uma única base de código. O Flutter se destaca pela sua capacidade de oferecer uma experiência de usuário consistente e de alto desempenho, além de possibilitar a construção de interfaces bonitas e altamente customizáveis por meio de seus widgets.

A organização das pastas dentro do diretório `\lib`, que é onde reside o código principal de um aplicativo Flutter, está sendo feita da seguinte maneira:

**\models**: Esta pasta contém as classes de modelo que representam os dados da aplicação. Elas são usadas para definir a estrutura e as propriedades dos dados que serão manipulados.
- `AppColors`: Define uma paleta de cores consistente para o aplicativo, incluindo cores primárias, de status (sucesso, alerta, erro), e várias tonalidades de preto, branco e cinza.
- `Medice`: Contém a classe Medice, que representa um medicamento com atributos como lote, datas de criação e atualização, identificador, nome e faixa (stripe). Inclui métodos para conversão de/para JSON.
- `Order`: Define a classe Order, representando um pedido de medicamento. Inclui atributos como data de criação, identificador, id do medicamento, observações, prioridade, quantidade, status, data de atualização e id do usuário. Também possui métodos para conversão de/para JSON.
- `Pyxis`: Contém a classe Pyxis, representando um dispositivo ou sistema de dispensação de medicamentos. Inclui atributos como nome, email, senha, data de criação, identificador e rótulo. Possui métodos para conversão de/para JSON.
- `User`: Define a classe User, representando um usuário do sistema. Inclui atributos como data de criação, email, senha, identificador, nome, status de plantão (onDuty) e função (role). Também possui métodos para conversão de/para JSON.

**\widgets**: Esta pasta armazena os widgets customizados que podem ser reutilizados em várias partes do aplicativo. Esses widgets são componentes de interface de usuário como botões, caixas de texto, ou elementos mais complexos.

**\services**: Contém os serviços que realizam operações como chamadas de API, acesso a banco de dados, ou outras funcionalidades que envolvem lógica de negócios e comunicação com fontes de dados externas.

O `OrderService` define métodos para recuperar pedidos de medicamentos, incluindo autenticação via token e manipulação de respostas JSON. O `UserService` gerencia a autenticação de usuários, oferecendo funcionalidades de login e cadastro, e armazena dados do usuário localmente usando SharedPreferences.

**\logic**: Esta pasta contém a lógica de negócios específica que não se enquadra diretamente em serviços ou controladores. A lógica auxilia na organização de funcionalidades centrais e independentes da camada de apresentação.
- `CalendarLogic`: Gerencia a lógica do calendário, incluindo a seleção de data, mudança de mês e ano, e geração de widgets de dias.
- `LocalStorageService`: Gerencia o armazenamento local usando o pacote `shared_preferences`, permitindo salvar, recuperar e remover valores.
- `NavBarState`: Gerencia o estado da barra de navegação, permitindo controlar qual item está selecionado.
- `showModal`: Função para exibir modais personalizados, usada para mostrar mensagens ao usuário.

**\controller**: Esta pasta armazena os controladores, que gerenciam a lógica de negócios e a comunicação entre as camadas de serviço e apresentação. Um exemplo de controlador é o UserController, responsável por lidar com as operações de login e cadastro dos usuários.

**\pages**: Aqui estão as diferentes telas (ou páginas) do aplicativo. Cada tela é geralmente representada por um widget separado e pode conter a lógica de apresentação e a interface de usuário específica daquela tela.
- `CheckOrderPage`: Exibe os detalhes de um pedido de medicamentos e permite ao usuário fornecer feedback sobre o pedido.
- `OrderDetailsPage`: Exibe os detalhes de um pedido de medicamentos, inclui informações como número do pedido, data, status, valor, prioridade, e o nome do sistema de dispensação (Pyxis).
- `LoginScreen`: Permite aos usuários inserirem seus detalhes de login e fazer login na aplicação.
- `SplashScreen`: Exibe o logotipo do aplicativo com uma animação de escala antes de redirecionar para a tela de introdução (onboarding).
- `NewOrderPage`: Criar uma nova ordem de medicamentos, permitindo aos usuários selecionar a quantidade desejada e marcar opções adicionais antes de enviar o pedido.
- `OnboardingScreen`: Tela de introdução que guia os usuários através de uma série de páginas de apresentação, destacando os recursos e incentivando-os a começar a usar o aplicativo.
- `OrdersPage`: Exibe os pedidos de medicamentos, permitindo que os usuários visualizem o histórico de pedidos e os pedidos pendentes, com opções de navegação entre as sessões.
- `ProfilePage`: Exibe informações pessoais do usuário, como nome, função e e-mail, permitindo visualizar e editar esses dados, além de oferecer a opção de fazer logout.
- `QRCodePage`: Permite aos usuários escanear QR codes e obter informações a partir deles, com a capacidade de pausar e retomar a câmera durante a digitalização.
- `SettingsPage`: Tela onde os usuários podem atualizar sua senha, fornecendo a senha anterior e a nova senha, com verificações de regras de senha visíveis ao inserir a nova senha.
- `SignUpScreen`: Tela onde os usuários podem criar uma nova conta, inserindo seu nome, e-mail e senha, e então avançar para o próximo passo.

Essa estrutura de pastas facilita a organização do código, a manutenção do projeto e a colaboração entre desenvolvedores, garantindo que cada componente do aplicativo esteja em seu devido lugar e que o código seja limpo e bem estruturado.

