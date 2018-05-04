# Consigna

## Algo de contexto

Las aplicaciones web se dividen usualmente en frontend y backend, que se
corresponden a los componentes ejecutados en el cliente y en el servidor. El
backend, ejecutado en el servidor, implementa los diferentes procesos de
negocios, que usualmente involucran interactuar con alguna base de datos.
Recibe requests de múltiples clientes al mismo tiempo, las encola y
eventualmente envía las respuestas correspondientes. El frontend, por otra
parte, es el encargado de la visualización de los componentes gráficos en el
browser, de enviar los pedidos (HTTP Requests) al servidor y de la conexión
entre los distintos servicios provistos por el backend.

Un patrón comúnmente utilizado para implementar aplicaciones web (y en general
para aplicaciones que tenga una interfaz de usuario) es el de
Model-View-Controller. En este patrón, los modelos (Models) son los componentes
principales del patrón y expresan los comportamientos de la aplicación, es
decir implementan las reglas de negocios y administran los datos de la misma.
En aplicaciones simples, suele existir un mapeo uno a uno entre de las tablas
en la base de datos y modelos. Las vistas (Views) manejan la interacción con el
usuario y determinan cómo se renderiza la información. Luego de una acción, las
vistas envían requests a los controladores. Los controladores (Controllers) son
las funciones que abstraen la lógica de la aplicación y la interacción entre
los objetos.

En la práctica, las tareas correspondientes frontend y al backend no están
claramente definidas y varían de aplicación en aplicación. En los últimos años,
el aumento en las capacidades de procesamiento del lado del cliente provocó que
más funcionalidades fueran ejecutadas en el navegador a través de Javascript.
Como consecuencia, se desarrollaron numerosos frameworks que permiten
implementar mucho de la lógica de la aplicación, como AngularJS, React o Vue.

Este laboratorio arranca sobre la base de lo trabajado en el laboratorio
anterior. El backend que se utilizará es el que se desarrolló en el laboratorio
1. Sin embargo, para aquellos que no hayan terminado el laboratorio, se les
provee de un backend estático que tendrán que completar para poder probar
correctamente el front end.

## El proyecto

Su tarea en este laboratorio será la de desarrollar el front end de la
aplicación a través del framework ReactJS. El front end se encarga de la
interacción con el usuario y se intercomunicará con el backend a través de la
API programada en este último.

Para evitar lidiar con configuraciones extra se les otorgará un esqueleto de la
aplicación ya previamente configurado, que a grandes razgos simplemente sea
un "Hello World!" en ReactJS. Ustedes tendrán que implementar el resto de las
vistas para comunicarse con el backend, para lo cuál puede utilizar como ejemplo
el frontend ya compilado para el laboratorio 1.

Tengan en cuenta que en este caso ustedes no tendrán que entregar un archivo
javascript compilado como el que se les dió en el laboratorio anterior sino que
entregarán el código en ReactJS para compilar. Este mismo debe ser desarrollado
en EcmaScript versión 6, utilizando jsx.

### Algunas simplificaciones

Para mantener simple nuestro prototipo, tomaremos algunas decisiones de diseño
que no son óptimas si estuviéramos implementando un producto real.

- El diseño del front end corre por su cuenta y es algo que no se evaluará.
  Verán que en EcmaScript 6 se puede hacer código muy similar a HTML. Si bien
  pueden aplicarse distintos estilos mediante CSS, esto no es requerido
  para la aprobación del laboratorio. Sin embargo se dejarán a mano diversos
  tutoriales y recursos disponibles para facilitar en caso de que se quiera
  entrar en cuestiones un poco más de estilo (e.g. bootstrap).

- La respuesta a errores por parte de las llamadas a la API no tiene que tener
  estilo, pero si se requiere que el error sea avisado de alguna manera en la
  iterfaz (e.g. mediante `alert`). No hace falta hacer diferentes manejos para
  distintos errores pero si ser claro que error devolvió la llamada.

- Se recomienda utilizar las últimas versiones de Firefox y/o Chrome para el
  trabajo con ReactJS, para evitar problemas de compatibilidad.


## Requerimientos Funcionales

1. Registro y Login de usuarios. Los usuarios pueden ser comensales (consumers)
   o proveedores (providers). El registro de usuarios es diferenciado, pero el
   login no, es una única pantalla para comensales y proveedores. Los
   comensales tienen un email, una dirección y una contraseña. Los proveedores
   tienen, además de lo anterior, un nombre del tienda y una distancia máxima
   de delivery. Todos están unívocamente determinados por su email.

2. Comensales (consumer):
  1. Ingresar una dirección y obtener un listado de proveedores que realicen
     deliveries a esa ubicación particular.
  2. Crear un pedido (order) a un único proveedor través de la selección de
     múltiples ítems. Una vez que todos los ítems del pedido han sido
     elegidos, el comensal puede pagar el pedido realizado. \[Esta acción
     afecta el saldo del proveedor y guarda el pedido con estado ‘payed’\]
  3. Consultar el listado de pedidos realizados con sus respectivos estados, y
     consultar su saldo total.

3. Proveedores (providers):
  1. Crear un menú compuesto de ítems. Cada ítem debe tener un nombre y un
     precio. Un proveedor sólo puede modificar los items creados por el mismo.
  2. Consultar su perfil donde se listan los pedidos realizados con sus
     respectivos estados  y el saldo (balance).
  3. Ver los pedidos pendientes y marcalos como finalizados. \[Esta acción
     cambia el estado del pedido a ‘delivered’\]

## Implementación

ReactJS tiene muchos aspectos de la programación declarativa. En general una
aplicación puede tener distintos componentes. Los componentes pueden tener
estado o no (i.e. ser completamente declarativos o funcionales). Se evaluará
que los componentes que no requieran estado estén definidos teniendo en cuenta
esa consideración. En términos generales, es mejor comensar un componente sin
estado y eventualmente agregarle estados si el componente requiere muchas
propiedades cuando es llamado. Se recomienda leer sobre [Presentational and
Container
Components](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0)

Por otro lado, algo muy importante es el diseño correcto en cuestiones de
programación asíncrona. Se les proveerá una librería para manejo de promesas en
Javascript para hacer las llamadas ajax a la API del servidor Sinatra. Tengan
en cuenta problemas como las condiciones de carrera que pueden llegar a darse
en este tipo de programación y el correcto uso de semáforos y otras técnicas
para evitar dichos problemas.

### Definición de la API


| Method | URL                         | Params                                                                                             | Code - Response                                                                                                                                                                                                                         |
|--------|-----------------------------|----------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| POST   | /api/login                  | {email: string, password: string}                                                                  | 200 {id: int, isProvider: bool}; 401 non existing user; 403 incorrect password                                                                                                                                                          |
| POST   | /api/logout                 | {}                                                                                                 | 200                                                                                                                                                                                                                                     |
| GET    | /api/consumers              | {}                                                                                                 | 200 [{id: int, email: string, location: int}]                                                                                                                                                                                           |
| POST   | /api/consumers              | {email: string, location: int, password: string}                                                   | 200 id as string; 400 no email/location/password; 409 existing user                                                                                                                                                                     |
| GET    | /api/providers              | {location: int or null}                                                                            | 200 [{id: int, email: string, location: int, store_name: string}]; 404 non existing location                                                                                                                                            |
| POST   | /api/providers              | {email: string, store_name: string, location: int, password: string, max_delivery_distance: float} | 200 id as string; 400 no email/location/store_name/password/max_delivery_distance; 409 existing user                                                                                                                                    |
| GET    | /api/users/{id:int}         | {}                                                                                                 | 200 {email:string, balance: float, location: int, max_delivery_distance\*: float, stora_name\*: string}; 404 non existing user; 400 invalid user_id                                                                                     |
| POST   | /api/users/delete/{id:int}  | {}                                                                                                 | 200; 404 non existing user                                                                                                                                                                                                              |
| GET    | /api/locations              | {}                                                                                                 | 200 [{id: int, name: string}]                                                                                                                                                                                                           |
| GET    | /api/items                  | {provider: int or null}                                                                            | 200 [{id: int, name: string, price: float, provider: int}];  404 non existing provider                                                                                                                                                  |
| POST   | /api/items                  | {name: string, price: float, provider: int}                                                        | 200 id as string; 409 duplicate item for provider; 404 non existing provider; 400 invalid name/price/provider                                                                                                                           |
| POST   | /api/items/delete/{id:int}  | {}                                                                                                 | 200; 404 non existing item; 403 item not belonging to logged provider                                                                                                                                                                   |
| GET    | /api/orders                 | {user_id: int}                                                                                     | 200 [{id: int, provider: int, provider_name: string, consumer: int, consumer_email: string, consumer_location: int, order_amount: float, status: option(‘payed’, ‘delivered’, ‘finished’)}]; 404 non existing user; 400 invalid user_id |
| GET    | /api/orders/detail/{id:int} | {}                                                                                                 | 200 [{id: int, name: string, price: float, amount: int}]; 404 non existing item; 400 invalid item id                                                                                                                                    |
| POST   | /api/orders                 | {provider: int, items: [{id: int,amount: int}], consumer: int}                                     | 200; 404 non existing provider/item/consumer; 400 invalid consumer/item/provider                                                                                                                                                        |
| POST   | /api/orders/delete/{id:int} | {}                                                                                                 | 200; 404 non existing order                                                                                                                                                                                                             |
| POST   | /api/deliver/{id:int}       | {}                                                                                                 | 200; 404 non existing order                                                                                                                                                                                                             |

\* Solamente si es aplicable

### Ejecución de la aplicación

La aplicación se ejecuta con el comando `rake`. Este comando comenzará una
ejecución en subproceso del servidor webpack que necesitan para trabajar con la
aplicación sin necesidad de compilar a cada rato. No obstante, si por alguna
razón el servidor de webpack o el de ruby fallan, puede que quede (o haya
quedado) una instancia del servidor de webpack funcionando. En cuyo caso
lanzará un error. Para asegurarse de que el servidor de webpack no esté
interrumpiendo el inicio de una nueva instancia pueden matar al proceso cuyo
número aparece en el archivo `node.pid` (sólo se crea una vez lanzado el
servidor por la aplicación ruby), haciendo `kill -9 <número en archivo
node.pid>`.

Para lanzar el servidor de webpack sin correr el servidor de ruby, lo pueden
hacer a través del comando `npm run dev`. Por otro lado, para compilar el
archivo `bundle.js` lo hacen a través del comando `npm run buil`.

## Requerimientos No funcionales

Además de los requerimientos funcionales, el laboratorio deberá cumplir los
siguientes requerimientos no funcionales:

### Implementación:

- Es importante que si la aplicación falla no lo haga de manera silenciosa, sin
  avisar por alerta o consola dónde falló.

- Componentes distintos en módulos distintos: No se requiere específicamente un
  componente por módulo, pero si que la modularización sea efectiva. Es decir,
  los componentes que son claramente distintos y tienen propósitos distintos no
  deberían estar en el mismo archivo.

- El diseño de los componentes deberá ser
  [atómico](http://bradfrost.com/blog/post/atomic-web-design/). Los componentes
  deben concentrarse en tener una funcionalidad específica, y no cubrir muchos
  aspectos.

- Tener cuidado con el manejo del estado. En general es buena idea que pocos
  componentes tengan que lidiar con estado. Por otra parte los componentes
  tienen que manejar solo su estado y/o [el de sus
  hijos](https://reactjs.org/docs/lifting-state-up.html). No hay manejo de
  estado entre componentes hermanos.

- Se requiere que trabajen utilizando
  [JSX](https://reactjs.org/docs/jsx-in-depth.html) como medio para declarar
  elementos del DOM.

- Se requiere que hagan chequeo de tipos utilizando
  [PropTypes](https://reactjs.org/docs/typechecking-with-proptypes.html) y lo
  respeten.


### Estilo:

- Se utilizará como base para el estilo de código en ReactJS las convenciones
  del [AirBNB React/JSX Style
  Guide](https://github.com/airbnb/javascript/tree/master/react). Se prestará
  mucha atención a que el código sea legible, con las identaciones correctas y
  el buen uso del espacio (i.e. no hagan líneas de más 80 caracteres).

- Se espera que hagan reutilización de código y hagan código
  [DRY](https://reactjs.org/docs/thinking-in-react.html#step-3-identify-the-minimal-but-complete-representation-of-ui-state)

### Entrega:

- Fecha de entrega: hasta el **11/05/2018** a las 23:59:59.999

Deberán crear un tag indicando el release para corregir.

`git tag -a lab-2 -m 'Entrega Laboratorio 2' && git push --tags`

**Si no está el tag no se corrige**. Tampoco se consideran commits posteriores
al tag.

## Recomendaciones y links de utilidad

- Busquen en Google antes de implementar y/o preguntar!
- El diseño atómico sirve para poder probar cada componente de a poco. Úsenlo!
- No renieguen con el estilo. Concéntrense en hacer funcionar el laboratorio.
  Si luego sobre tiempo pueden hacerlo lindo.
- **Aprendan a utilizar la consola de developer en Chrome y/o Firefox. En
  particular instalen el AddOn [ReactDev
  Tools](https://github.com/facebook/react-devtools) que les va a facilitar
  mucho el trabajo!**

### Links útiles

#### Lectura Obligatoria

- [Tutorial de React](https://reactjs.org/tutorial/tutorial.html): Háganlo!
- [Componentes de React](https://reactjs.org/docs/react-component.html)
- [Documentación de axios](https://github.com/axios/axios)
- [Documentación de React
  Router](https://reacttraining.com/react-router/web/guides/philosophy)
- [Presentational and Container
  Components](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0)
- [Atomic web design](http://bradfrost.com/blog/post/atomic-web-design/)
- [Lifting the state up](https://reactjs.org/docs/lifting-state-up.html)
- [JSX](https://reactjs.org/docs/jsx-in-depth.html)
- [PropTypes](https://reactjs.org/docs/typechecking-with-proptypes.html)
- [AirBNB React/JSX Style
  Guide](https://github.com/airbnb/javascript/tree/master/react)
- [Thinking in React](https://reactjs.org/docs/thinking-in-react.html)
- [ReactDev Tools](https://github.com/facebook/react-devtools)

#### Otras Referencias

- [9 things every React.js beginner should
  know](https://camjackson.net/post/9-things-every-reactjs-beginner-should-know)
- [Documentación de React](https://reactjs.org/docs/hello-world.html)
- [ReactStrap](https://reactstrap.github.io/)
- [Lodash](https://lodash.com/), una librería para trabajar más cómodamente con
arreglos, objetos y demás.
- [Bootstrap 4](https://getbootstrap.com/)

## Puntos estrella

Para implementar puntos estrella se puede cambiar cualquier parte de la
implementación. Es posible que deban modificar la especificación de la API.
Dichos cambios deberán ser documentados en el README, junto con una
justificación de por qué así lo decidieron y cómo efectivamente comprobar que
el punto estrella funciona.  Los puntos estrella bien pueden ser algo
únicamente del front end, o que requieran tocar también el backend.

Recordá que los puntos estrella son necesarios para recuperar el lab y para
rendirlo en el final, tanto regulares como libres. Te proponemos las siguientes
opciones:

### 1- Chequeo de rutas para evitar acceso a lugares no permitidos

Deberán chequear que cuando un usuario no tiene permisos de acceso a una página
no permitida la aplicación redirija (e.g. si un usuario sin loguear busca un
delivery, que lo redirija a la página de login, o si el usuario está logueado y
quiere acceder a la página de login, que lo redirija a la página principal,
etc.). Para ello chequear el atributo `render` en [React
Router](https://reacttraining.com/react-router/core/api/Route/render-func)

### 2- Chequear expiración de sesiones con axios

Cuando ejecutan un comando de axios, deberían [chequear que la sesión no haya
expirado](https://stackoverflow.com/questions/43326383/using-session-cookies-in-react)
en cuyo caso deberían redireccionar y/o cambiar los estados para reflejar dicho
cambio.

### 3- Comentarios

Proveer las funcionalidades para que los comensales puedan puntuar y dejar
comentarios de texto sobre la comida. Esta acción marca el pedido con el estado
‘finished’. Los comensales serán capaces de ver el rating de los proveedores y
listar todos los comentarios anteriores. Los proveedores podrán acceder a esta
información desde su página de perfil.

### 4- Implementar la aplicación utilizando la librería Redux

Aprender sobre el patrón [flux](https://facebook.github.io/flux/) y en
particular la implementación [redux](https://redux.js.org/), que es una
simplificación de dicho patrón. Implementar todo el laboratorio siguiendo dicho
patrón.

### 5- Full authentication via Token

Modificar el backend para que soporte [autenticación via
tokens](http://secondforge.com/blog/2014/11/05/simple-api-authentication-in-sinatra/)
o bien [autenticación via
JWT](https://auth0.com/blog/ruby-authentication-secure-rack-apps-with-jwt/).
Hacer lo propio para manejar dichos datos desde el lado del cliente con React.
Buscar documentación al respecto.

