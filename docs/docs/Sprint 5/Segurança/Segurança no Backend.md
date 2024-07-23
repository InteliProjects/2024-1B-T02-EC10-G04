---
title: Segurança no Backend
sidebar_position: 2
slug: backend-security
---

# Segurança no Backend

Este documento descreve as medidas de segurança implementadas no backend do nosso projeto. A segurança é garantida através da utilização de JWT (JSON Web Tokens) para autenticação e controle de acesso baseado em papéis (RBAC).

## Controle de Acesso Baseado em Papéis (RBAC)

### O que é RBAC?

RBAC, ou Role-Based Access Control, é um método de restrição de acesso a recursos com base nos papéis (roles) dos usuários dentro de uma organização. Em vez de conceder permissões diretamente a cada usuário, as permissões são atribuídas a papéis, e os usuários são atribuídos a esses papéis. Isso facilita a gestão de permissões, especialmente em sistemas grandes e complexos.

### Implementação de RBAC com JWT

No nosso projeto, implementamos RBAC usando JWT para autenticação e autorização. Cada usuário, ao se autenticar, recebe um token JWT que contém informações sobre seu papel. Esse token é utilizado para validar o acesso do usuário a diferentes partes do sistema.

#### O que é JWT?

JWT (JSON Web Token) é um padrão aberto que define uma maneira compacta e autossuficiente de transmitir informações entre as partes como um objeto JSON. Essas informações podem ser verificadas e confiáveis porque são assinadas digitalmente.

Um JWT é composto por três partes:

1. **Header**: Contém informações sobre o tipo de token e o algoritmo de assinatura.
2. **Payload**: Contém as declarações (claims), que são as informações sobre uma entidade (geralmente, o usuário) e metadados adicionais.
3. **Signature**: É a assinatura gerada a partir do header, payload e uma chave secreta. A assinatura garante que o token não foi alterado.

#### Como Utilizamos JWT no Nosso Sistema

1. **Login do Usuário**: O usuário faz login e, se autenticado com sucesso, recebe um JWT que inclui suas informações e o papel associado.

   - Durante o login, o sistema gera um JWT contendo o ID do usuário, data de expiração e emissor.
   - Exemplo de geração de JWT:

     ```golang
     func generateJWT(user *entity.User) (string, error) {
         expirationTime := time.Now().Add(72 * time.Hour) // Token expira em 72 horas
         claims := &jwt.RegisteredClaims{
             Subject:   user.ID,
             ExpiresAt: jwt.NewNumericDate(expirationTime),
             Issuer:    "InteliModulo10",
         }

         token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
         tokenString, err := token.SignedString([]byte(os.Getenv("JWT_SECRET_KEY")))

         if err != nil {
             return "", err
         }

         return tokenString, nil
     }
     ```

2. **Verificação do JWT**: Em cada requisição protegida, o middleware de autenticação verifica o JWT para garantir que o usuário tenha um token válido e que seu papel autorize o acesso ao recurso solicitado.

   - O middleware extrai o token do cabeçalho da requisição, verifica sua validade e extrai as informações contidas nele.
   - Exemplo de middleware de autenticação:

     ```golang
     func AuthMiddleware(userRepository entity.UserRepository, requiredRole string) gin.HandlerFunc {
         return func(c *gin.Context) {
             tokenString, err := getTokenFromHeader(c)
             if err != nil {
                 c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
                 c.Abort()
                 return
             }

             claims, err := parseToken(tokenString)
             if err != nil {
                 c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid token"})
                 c.Abort()
                 return
             }

             user, err := userRepository.FindUserById(claims.Subject)
             if err != nil || user == nil {
                 handleUserError(c, err)
                 return
             }

             if user.Role != requiredRole {
                 c.JSON(http.StatusForbidden, gin.H{"error": "You don't have permission to access this route"})
                 c.Abort()
                 return
             }

             c.Set("userID", user.ID)
             c.Next()
         }
     }
     ```

3. **Verificação de Papel (Role)**: O middleware verifica se o papel do usuário é adequado para acessar a rota protegida.
   - Se o papel do usuário não corresponder ao papel exigido, o acesso é negado.

### Papéis no Sistema

Os papéis são definidos e controlados no banco de dados como um enum com os seguintes valores:

- `admin`: Usuários 'master' do sistema, com acesso total.
- `user`: Usuários base que utilizam os serviços, como solicitar medicamentos.
- `collector`: Responsável por receber e executar pedidos.
- `manager`: Responsável por gerir os pedidos e também pode executá-los.

### Vantagens do RBAC

- **Facilidade de Gestão**: Permissões são atribuídas a papéis, não diretamente aos usuários, facilitando a administração.
- **Segurança**: Reduz o risco de erros na atribuição de permissões, garantindo que os usuários só possam acessar o que é permitido pelo seu papel.
- **Escalabilidade**: Facilita a adição de novos usuários e a modificação de permissões à medida que o sistema cresce.

### Desvantagens do RBAC

- **Rigidez**: Pode ser inflexível em sistemas onde as necessidades de acesso variam muito entre os usuários.
- **Complexidade**: Em sistemas muito grandes, a definição e gestão dos papéis e permissões podem se tornar complexas.

## Futuras Melhorias

Para aprimorar ainda mais a segurança do sistema, planeja-se a implementação de Controle de Acesso Baseado em Atributos (ABAC).

### O que é ABAC?

ABAC, ou Attribute-Based Access Control, é um método de controle de acesso que utiliza atributos (como departamento, função, tempo de acesso) para conceder permissões. Isso permite uma segurança mais granular e flexível, onde políticas complexas podem ser definidas com base em múltiplos atributos.

### Vantagens do ABAC

- **Flexibilidade**: Permite definir políticas de acesso mais detalhadas e complexas.
- **Granularidade**: Permite um controle de acesso mais específico e preciso, adequado para ambientes com requisitos de segurança elevados.

### Planejamento para Implementação de ABAC

A implementação do ABAC visa:

- Separar quem tem acesso a quais recursos específicos.
- Permitir uma segurança mais granular, onde ações específicas podem ser autorizadas com base em atributos do usuário, do recurso e do contexto.

Esta melhoria trará uma camada adicional de segurança, essencial para sistemas que exigem um controle de acesso mais detalhado e preciso.

## Conclusão

A segurança no nosso backend é garantida atualmente através da implementação de RBAC com JWT, oferecendo uma solução robusta e escalável para controle de acesso. No futuro, planejamos evoluir para ABAC, buscando uma segurança ainda mais granular e adaptável às necessidades específicas dos usuários e recursos do sistema.
