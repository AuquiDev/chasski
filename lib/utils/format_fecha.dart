import 'package:timezone/timezone.dart' as tz;

// Lista de días en español
List<String> diasSemana = ["Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"];

// Meses del año en español
List<String> mesesAnio = [
  "Ene",
  "Feb",
  "Mar",
  "Abr",
  "May",
  "Jun",
  "Jul",
  "Ago",
  "Sep",
  "Oct",
  "Nov",
  "Dic"
];

String formatFecha(DateTime fecha) {
  // Convertir la fecha a la zona horaria de América/Lima
  // final tz.TZDateTime fechaLima =
  //     tz.TZDateTime.from(fecha, tz.getLocation('America/Lima'));
  // fecha = fechaLima;
  //Obtener el día de la semana, el día del mes y el mes en texto
  String diaSemana = diasSemana[fecha.weekday - 1];
  String diaMes = fecha.day.toString();
  String mesAno = mesesAnio[fecha.month - 1];
  String ano = fecha.year.toString();

  String fechaFormateada = "$diaSemana, $diaMes $mesAno $ano";
  return fechaFormateada;
}

//FECHA HORA EXPRESION LARGA 
String formatFechaHoraNow(DateTime fecha) {
  // Convertir la fecha a la zona horaria de América/Lima
  final tz.TZDateTime fechaLima =
      tz.TZDateTime.from(fecha, tz.getLocation('America/Lima'));
  fecha = fechaLima;
  // Obtener el día de la semana, el día del mes y el mes en texto
  String diaSemana = diasSemana[fecha.weekday - 1];
  String diaMes = fecha.day.toString();
  String mesAno = mesesAnio[fecha.month - 1];
  String ano = fecha.year.toString();

  // Obtener la hora y el minuto
  // String hora = fecha.hour.toString().padLeft(2, '0');
  String minuto = fecha.minute.toString().padLeft(2, '0');

  // Determinar si es AM o PM
  String periodo = (fecha.hour < 12) ? 'AM' : 'PM';

  // Convertir la hora al formato de 12 horas
  int hora12 = (fecha.hour > 12) ? fecha.hour - 12 : fecha.hour;
  // Crear la cadena formateada
  String fechaFormateada =
      "$diaSemana, $diaMes $mesAno $ano a las $hora12:$minuto $periodo";
  return fechaFormateada;
}




String formatFechaPDfhora(DateTime fecha) {
  // Convertir la fecha a la zona horaria de América/Lima
  // final tz.TZDateTime fechaLima =
  //     tz.TZDateTime.from(fecha, tz.getLocation('America/Lima'));
  // fecha = fechaLima;

  String minuto = fecha.minute.toString().padLeft(2, '0');
  String segundo = fecha.second.toString().padLeft(2, '0');

  // Determinar si es AM o PM
  String periodo = (fecha.hour < 12) ? 'AM' : 'PM';

  // Convertir la hora al formato de 12 horas
  int hora12 = (fecha.hour > 12) ? fecha.hour - 12 : fecha.hour;

  // Crear la cadena formateada
  String fechaFormateada = "$hora12:$minuto:$segundo $periodo";

  return fechaFormateada;
}

String formatEventDates(DateTime startDate, DateTime endDate) {
  // List of month names in Spanish
  const List<String> months = [
    'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
  ];

  // Extract day, month, and year for both dates
  String startDay = startDate.day.toString().padLeft(2, '0');
  String startMonth = months[startDate.month - 1];
  int startYear = startDate.year;

  String endDay = endDate.day.toString().padLeft(2, '0');
  String endMonth = months[endDate.month - 1];
  int endYear = endDate.year;

  // Check if the month and year are the same for both dates
  if (startMonth == endMonth && startYear == endYear) {
    return '$startDay y $endDay de $startMonth del $startYear';
  } else if (startYear == endYear) {
    return '$startDay de $startMonth y $endDay de $endMonth del $startYear';
  } else {
    return '$startDay de $startMonth del $startYear y $endDay de $endMonth del $endYear';
  }
}