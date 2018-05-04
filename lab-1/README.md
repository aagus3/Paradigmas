# Laboratorio 1 - Paradigmas 2018

## Programación Orientada a Objetos con Ruby

### Informe Proyecto

**Introducción**

En este informe se detallara la estructura de la aplicación, las decisiones de diseño tomadas, dificultades que encontramos y como las resolvimos.

**Estructura de las clases**

Para aprovechar al máximo las propiedades de herencia de Ruby se optó por la siguiente implementación de clases:

- Model
- Locations < Model
- Item < Model
- Order < Model
- User < Model
- Consumer < User
- Provider < User


**Model**

Aquí se completaron los métodos faltantes que se usaran en las subclases.

**Locations**

Aquí se inicializan las ubicaciones disponibles de los usuarios, tanto ´consumers´ como ´providers´. No se pueden cambiar desde la pagina.

Tiene los atributos necesarios para hacer el punto estrella respectivo, pero por cuestión de tiempo no se implemento.

**Item**

Aqui se inicializan los items creados por los ´providers´ para la elección de los ´consumers´. Donde estos eligen para conformar una ´Orden´.

**Order**

Aquí se inicializan las ordenes creadas por los ´consumer´ a partir de los ítems mencionados anteriormente, donde cada orden esta unívocamente asociada a un ´consumer´ y a un ´provider´. También se realiza el computo del total a pagar por el ´consumer´.

**User**

Superclase de los usuarios, tanto ´consumers´ como ´providers´. Solo contiene los atributos a heredar a las subclases. En consecuencia de esta implementación, cada subclase tiene sus propias instancias y base de datos.

**Consumer**

Aquí se inicializan los nuevos ´consumers´ y tambien se utiliza durante la carga de los mismos. Desde aquí se computa el saldo de cada ´consumer´ así también el pago de la orden hecha por dicho ´consumer´.

**Provider**

Aquí se inicializan los nuevos ´providers´ y tambien se utiliza durante la carga de los mismos. Desde aquí se computa el saldo de cada ´provider´ así también el pago de la orden recibida por dicho ´provider´.


## Dificultades encontradas

Al no tener mucho conocimiento del lenguaje, se trato de implementar funciones que venían provistas. Por lo tanto se perdió mucho tiempo útil. Luego fueron completadas en la clase ´Model´.

Una vez que entendimos el manejo de datos, la implementación se tornó mecánica como se puede apreciar en la historia de los commits realizados.

Por ultimo, los tests brindados por ustedes, nos sirvieron mucho para saber como se debían comprobar los parámetros que manipulábamos, ya que la aplicación funcionaba correctamente pero no era lo suficientemente robusta.


### Notas

El "users test" se modificó mínimamente en "test register consumer" y en "test user details" ya que nuestra implementación usa como parámetros ´username´ y no ´email´ como originalmente pedían los correspondientes tests.
