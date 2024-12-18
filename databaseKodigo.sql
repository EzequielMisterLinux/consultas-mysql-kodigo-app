Create database KodigoApp;
use KodigoApp;

CREATE TABLE proveedores (
id_proveedor int auto_increment primary key not null,
nombre varchar(50) not null,
telefono varchar(35) null
);


CREATE TABLE categorias (
id_categoria int auto_increment primary key not null,
nombre varchar(20) not null
);


CREATE TABLE productos (
id_producto INT AUTO_INCREMENT PRIMARY KEY not null,
nombre VARCHAR(50) NOT NULL,
precio DECIMAL(10, 2) NOT NULL,
cantidad INT NOT NULL,
id_proveedor INT,
id_categoria INT,
FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor),
FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

insert into proveedores (nombre, telefono) values ("pan limbo", "50376757432");
insert into categorias (nombre) values ("panes");
insert into productos (nombre, precio, cantidad, id_categoria, id_proveedor) values ("pan de arroz", 1.50 , 10, 1, 1);
select productos.nombre , precio, categorias.nombre as category from productos
inner join categorias on categorias.id_categoria =  productos.id_categoria;

select * from proveedores;
select * from productos;
select * from categorias;



insert into proveedores (nombre) values ("nokia");
insert into categorias (nombre) values ("serie Mi");

insert into productos (nombre, precio, cantidad, id_proveedor, id_categoria) values ("xiaomi mi 13 ultra", 999.99, 9 , 2, 2);
insert into productos (nombre, precio, cantidad, id_proveedor, id_categoria) values ("xiaomi mi 13", 599.99, 9 , 2, 2);
insert into productos (nombre, precio, cantidad, id_proveedor, id_categoria) values ("xiaomi mi 13 pro", 799.99, 9 , 2, 2);

/*
Obtener todos los productos con su respectivo proveedor (detallar la información del proveedor)
*/

select proveedores.nombre as "nombre del proveedor", proveedores.telefono as "telefono de proveedor", productos.nombre as "nombre del producto" from productos
inner join proveedores on proveedores.id_proveedor = productos.id_proveedor
where proveedores.id_proveedor = 2;


/*
los productos que el precio sea mayor a 15
*/
SELECT * FROM productos
WHERE precio > 15.00;

/*
Listar los proveedores que no tienen teléfono registrado.
*/
select * from proveedores
where telefono is null;


/*
Contar cuántos productos hay por proveedor.
*/

SELECT pr.nombre AS proveedor, COUNT(p.id_producto) AS total_productos
FROM proveedores pr
LEFT JOIN productos p ON pr.id_proveedor = p.id_proveedor
GROUP BY pr.id_proveedor;


/*

Calcular el valor total del inventario (cantidad * precio) para cada producto.

*/

SELECT nombre, (precio * cantidad) AS valor_total
FROM productos;

/*
Obtener el proveedor con más productos registrados.
*/

SELECT pr.nombre AS proveedor, COUNT(p.id_producto) AS total_productos
FROM proveedores pr
JOIN productos p ON pr.id_proveedor = p.id_proveedor
GROUP BY pr.id_proveedor
ORDER BY total_productos DESC
LIMIT 1;


/*
Obtener el número total de productos por cada categoría. Usa la cláusula GROUP BY
 para agrupar los resultados por categoría.
*/

SELECT c.nombre AS categoria, COUNT(p.id_producto) AS total_productos FROM productos p 
INNER JOIN categorias c ON p.id_categoria = c.id_categoria GROUP BY c.nombre;


/*

Asignar una clasificación a los productos basándote en su precio: "Alto" 
para productos con un precio mayor a 20.00, y "Bajo" para los demás. Utiliza la cláusula CASE.

*/

SELECT p.nombre AS PRODUCTO, 
       CASE 
           WHEN p.precio > 20.00 THEN 'Alto'
           ELSE 'Bajo'
       END AS CLASIFICACION
FROM productos p;


/*
Obtener todos los productos junto con el nombre del proveedor, incluso si algunos proveedores
 no tienen productos asociados. Usa la cláusula LEFT JOIN.
*/

select proveedores.nombre as "nombre proveedor", productos.nombre from productos 
left join proveedores on productos.id_proveedor = proveedores.id_proveedor;

SELECT p.nombre AS producto, pr.nombre AS proveedor
FROM productos p
LEFT JOIN proveedores pr ON p.id_proveedor = pr.id_proveedor;


/*
Calcular el precio promedio de los productos en cada categoría. Usa la cláusula GROUP BY para agrupar 
los productos por categoría.
*/

SELECT c.nombre AS categoria, AVG(p.precio) AS precio_promedio
FROM categorias c
JOIN productos p ON c.id_categoria = p.id_categoria
GROUP BY c.id_categoria;

select categorias.nombre as "nombre categoria", productos.nombre, productos.precio from productos 
inner join categorias on productos.id_categoria = categorias.id_categoria
group by categorias.nombre;


/*
Filtrar las categorías que tienen más de dos productos registrados. Utiliza la cláusula HAVING
 para aplicar una condición de agregación.
*/


SELECT c.nombre, COUNT(p.id_producto) AS cantidad
FROM categorias c
JOIN productos p ON c.id_categoria = p.id_categoria
GROUP BY c.id_categoria
HAVING COUNT(p.id_producto) > 2;

/*
Aumentar en un 10% el precio de todos los productos de la categoría "Electrónica" u otra categoría.
*/
UPDATE productos
SET precio = precio * 1.10
WHERE id_categoria = (SELECT id_categoria FROM categorias WHERE nombre = 'serie Mi');
select * from productos;


/*
Obtener el producto más caro de cada categoría. Utiliza una subconsulta en la cláusula WHERE 
para obtener el máximo precio por categoría.
*/
SELECT nombre, precio, id_categoria
FROM productos
WHERE precio = (
    SELECT MAX(precio)
    FROM productos p2
    WHERE p2.id_categoria = productos.id_categoria
);



/*
Verificar si hay proveedores que tienen productos cuyo precio es menor a 10.00. Utiliza la cláusula 
EXISTS con una subconsulta.
*/

SELECT nombre
FROM proveedores pr
WHERE EXISTS (
    SELECT 1
    FROM productos p
    WHERE p.id_proveedor = pr.id_proveedor AND p.precio < 10.00
);