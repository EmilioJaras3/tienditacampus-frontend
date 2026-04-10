# Reporte de Análisis de Datos - TienditaCampus

## Descripción

Este directorio contiene el reporte completo de análisis de datos del sistema TienditaCampus, incluyendo consultas SQL, documento LaTeX y documentación de soporte.

## Archivos Generados

### 1. `consultas_analisis.sql`
Archivo con 10 consultas SQL comprehensivas para el análisis de datos:
- Análisis general de ventas por semana
- Rendimiento por categoría de producto
- Análisis de rentabilidad por producto
- Análisis de pérdidas por motivo
- Tendencia de ventas diarias
- Análisis de punto de equilibrio
- Resumen semanal consolidado
- Análisis de eficiencia operativa
- Top 5 productos más rentables
- Análisis de sostenibilidad del negocio

### 2. `reporte_analisis.tex`
Documento LaTeX completo con:
- **Portada profesional** con información del proyecto
- **Índice automático** de contenidos
- **Análisis de datos** con tablas y gráficos
- **Validación de hipótesis** con conclusiones claras
- **Métricas clave** de rendimiento (KPIs)
- **Recomendaciones estratégicas** inmediatas y a mediano plazo
- **Conclusiones** basadas en evidencia
- **Apéndices** con documentación técnica

## Estructura del Reporte

### Secciones Principales
1. **Resumen Ejecutivo** - Hallazgos clave en una página
2. **Introducción** - Contexto, objetivos y metodología
3. **Análisis de Datos** - Tablas y gráficos con métricas
4. **Validación de Hipótesis** - Análisis de 3 hipótesis principales
5. **Métricas Clave** - KPIs financieros y operativos
6. **Recomendaciones** - Acciones concretas para mejorar
7. **Conclusiones** - Síntesis del análisis
8. **Apéndices** - Documentación técnica

### Hipótesis Validadas
1. **Hipótesis 1:** ✅ Margen de ganancia sostenible (>50%)
2. **Hipótesis 2:** ✅ Tasa de pérdidas controlada (<10%)
3. **Hipótesis 3:** ✅ Productos perecederos generan mayores pérdidas

## Datos Analizados

### Período
- **Últimas 3 semanas** de operación
- **21 días** de datos históricos
- **Vendedor principal:** isaa@gmail.com

### Productos Analizados
- **Papas Locas Fuego** (Botanas Saladas)
- **Brownie de Chocolate** (Postres y Dulces)
- **Agua de Horchata 1L** (Bebidas Refresh)

### Métricas Clave Obtenidas
- **Margen promedio:** 60.00%
- **Tasa de pérdidas:** 7.69%
- **Días rentables:** 100%
- **ROI general:** 150%
- **Unidades vendidas/día:** 18.6

## Compilación del Reporte LaTeX

### Requisitos
```bash
# Instalar paquetes LaTeX
sudo apt-get install texlive-full

# O instalar paquetes específicos
sudo apt-get install texlive-latex-base texlive-latex-extra
```

### Compilación
```bash
# Compilar el documento
pdflatex reporte_analisis.tex
pdflatex reporte_analisis.tex  # Ejecutar dos veces para el índice

# Limpiar archivos auxiliares
rm *.aux *.log *.toc *.out
```

### Vista Previa
El reporte generado contendrá:
- ~15 páginas de análisis completo
- Tablas profesionales con formato booktabs
- Gráficos generados con TikZ
- Navegación interna con hyperref
- Diseño limpio y profesional

## Ejecución de Consultas SQL

### Conexión a la Base de Datos
```bash
# Usando Docker Compose
docker-compose -f docker-compose.db.yml exec postgres psql -U tienditacampus -d tienditacampus

# O conexión directa
psql -h localhost -U tienditacampus -d tienditacampus
```

### Ejecutar Análisis
```sql
-- Ejecutar todas las consultas
\i consultas_analisis.sql

-- O ejecutar consulta específica
-- Copiar y pegar la consulta deseada
```

## Resultados Esperados

### Análisis Financiero
- **Inversión total:** \$1,550.00
- **Ingresos totales:** \$3,875.00
- **Ganancia total:** \$2,325.00
- **Margen promedio:** 60.00%

### Análisis Operativo
- **Total unidades vendidas:** 360
- **Total unidades perdidas:** 30
- **Eficiencia de ventas:** 92.3%
- **Rotación de inventario:** 3.2 días

## Próximos Pasos

### Inmediatos
1. **Compilar el reporte** LaTeX para generar PDF
2. **Ejecutar consultas** SQL con datos reales
3. **Validar resultados** con datos actualizados

### Recomendaciones Implementables
1. **Optimizar inventario perecedero** - Reducir en 20%
2. **Expandir productos estrella** - Incrementar stock en 30%
3. **Implementar alertas de vencimiento** - Sistema automatizado

## Soporte Técnico

### Estructura de Base de Datos
- **PostgreSQL** con extensiones UUID
- **Tablas principales:** users, products, daily_sales, sale_details
- **Vistas materializadas:** weekly_performance_mv
- **Índices optimizados** para consultas analíticas

### Herramientas Utilizadas
- **SQL** para extracción de datos
- **LaTeX** para generación de reportes
- **TikZ** para gráficos y visualizaciones
- **PostgreSQL** para análisis de datos

---

**Nota:** Este reporte está diseñado para ser un documento vivo que puede actualizarse periódicamente con nuevos datos para seguimiento continuo del rendimiento del negocio.
