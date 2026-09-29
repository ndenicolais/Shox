// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get intro_title => 'Shox';

  @override
  String get intro_screen_load_data_error =>
      'No se pudieron cargar los datos del usuario';

  @override
  String get onboarding_first_title => 'Añade';

  @override
  String get onboarding_first_description =>
      'Añade todos tus zapatos a esta caja digital para tenerlos siempre contigo. Organice fácilmente su colección y mantenga un registro de cada par que tiene a mano.';

  @override
  String get onboarding_second_title => 'Filtra';

  @override
  String get onboarding_second_description =>
      'Filtra rápidamente tus zapatos favoritos usando filtros avanzados. Busca por marca, modelo, color y más, y descubre todas las características de tus zapatos en un instante.';

  @override
  String get onboarding_third_title => 'Muestra';

  @override
  String get onboarding_third_description =>
      'Muestra fichas detalladas de sus zapatos con todas sus características. Desde las especificaciones técnicas hasta las fotos, explora todos los aspectos de tus zapatos con una interfaz intuitiva.';

  @override
  String get onboarding_fourth_title => 'Explora';

  @override
  String get onboarding_fourth_description =>
      'Explora varios gráficos coloridos que muestran estadísticas detalladas sobre el total y las especificaciones de tus zapatos en la base de datos.';

  @override
  String get onboarding_next => 'Next';

  @override
  String get onboarding_finish => 'Comienza';

  @override
  String get welcome_text => 'Hola';

  @override
  String get welcome_login => 'Login';

  @override
  String get welcome_signup => 'Signup';

  @override
  String get signup_screen_title => 'Registro';

  @override
  String get signup_screen_text => 'Registrarse';

  @override
  String get signup_screen_account => '¿Tienes una cuenta? ';

  @override
  String get signup_screen_login => 'Iniciar sesión';

  @override
  String get signup_toast_success => '¡Registro exitoso!';

  @override
  String get signup_toast_error_email_already_register =>
      'El correo electrónico introducido ya ha sido registrado como correo electrónico personal';

  @override
  String get signup_toast_error_generic => 'Error durante el registro:';

  @override
  String get login_screen_title => 'Inicio de sesión';

  @override
  String get login_screen_text => 'Iniciar sesión';

  @override
  String get login_screen_remember => 'Recuérdame';

  @override
  String get login_screen_password => '¿Olvidaste tu contraseña?';

  @override
  String get login_screen_account => '¿No tienes una cuenta? ';

  @override
  String get login_screen_signup => 'Regístrate';

  @override
  String get login_toast_success => '¡Inicio de sesión exitoso!';

  @override
  String get login_toast_error_email_not_found =>
      'El correo electrónico introducido no corresponde a ninguna cuenta';

  @override
  String get login_toast_error_invalid_password =>
      'La contraseña introducida no corresponde a ninguna cuenta';

  @override
  String get session_expired_message =>
      'Tu sesión ha caducado. Inicia sesión de nuevo.';

  @override
  String get startup_error_message =>
      'No se puede iniciar la app. Comprueba tu conexión a internet e inténtalo de nuevo.';

  @override
  String get login_toast_error_network =>
      'No se puede conectar con Google. Comprueba tu conexión a internet e inténtalo de nuevo.';

  @override
  String get login_toast_error_generic => 'Error durante el inicio de sesión:';

  @override
  String get logout_toast_success => '¡Hasta pronto!';

  @override
  String get logout_toast_error_generic => 'Error durante el cierre de sesión';

  @override
  String get reset_password_screen_title => 'Restablecer contraseña';

  @override
  String get reset_password_screen_description =>
      'Introduce tu correo electrónico para recibir el enlace con el procedimiento para restablecer la contraseña';

  @override
  String get reset_password_screen_text => 'Restablecer contraseña';

  @override
  String get reset_password_form_email => 'Correo electrónico';

  @override
  String get reset_password_form_email_field =>
      'Introduce el correo electrónico';

  @override
  String get reset_password_toast_success =>
      'Correo electrónico para restablecer la contraseña enviado a: ';

  @override
  String get reset_password_toast_error_email_not_found =>
      'El correo electrónico introducido no está registrado';

  @override
  String get reset_password_toast_error_password =>
      'Error durante el restablecimiento de la contraseña';

  @override
  String get gender_selection_screen_title => 'Seleccionar Género';

  @override
  String get gender_selection_screen_subtitle => 'Elige Tu Género';

  @override
  String get gender_selection_screen_description =>
      'Esto nos ayudará a personalizar tu experiencia de colección de zapatos';

  @override
  String get gender_selection_button => 'Continuar';

  @override
  String get gender_selection_toast_success =>
      'Preferencia guardada correctamente!';

  @override
  String get gender_selection_toast_error => 'Error al guardar la preferencia';

  @override
  String get gender_male => 'Hombre';

  @override
  String get gender_female => 'Mujer';

  @override
  String get gender_other => 'Otro';

  @override
  String get validator_name => 'Nombre';

  @override
  String get validator_name_empty => 'El nombre no puede estar vacío';

  @override
  String get validator_name_hint => 'Introduce tu nombre';

  @override
  String get validator_name_required => 'El nombre es requerido';

  @override
  String get validator_name_error => 'Inválido nombre: ';

  @override
  String get validator_email => 'Email';

  @override
  String get validator_email_missing_special => 'Símbolo @ faltante';

  @override
  String get validator_email_missing_dot => 'Símbolo . faltante';

  @override
  String get validator_email_hint => 'Introduce tu email';

  @override
  String get validator_email_required => 'Email es requerido';

  @override
  String get validator_email_error => 'Inválido email: ';

  @override
  String get validator_password => 'Password';

  @override
  String get validator_password_missing_upper => 'Letra mayúscula faltante';

  @override
  String get validator_password_missing_lower => 'Letra pequeña faltante';

  @override
  String get validator_password_missing_digit => 'Número faltante';

  @override
  String get validator_password_missing_special => 'Símbolo faltante';

  @override
  String get validator_password_missing_lenght =>
      'La password debe tener una longitud de al menos 8 caracteres';

  @override
  String get validator_password_hint => 'Introduce tu password';

  @override
  String get validator_password_required => 'Password es requerido';

  @override
  String get validator_password_error => 'Inválido password: ';

  @override
  String get permission_storage_denied => 'Permiso de almacenamiento denegado';

  @override
  String get permission_storage_toast =>
      'Conceda el permiso de almacenamiento desde la configuración';

  @override
  String get permission_camera_denied => 'Permiso de cámara denegado';

  @override
  String get permission_camera_toast =>
      'Conceda el permiso de la cámara desde la configuración';

  @override
  String get home_screen_welcome_text => 'Hola';

  @override
  String get home_screen_search_bar => 'Buscar por Brand';

  @override
  String get home_screen_filter_title => 'Filtrar';

  @override
  String get home_screen_filter_color_primary => 'Color Primario';

  @override
  String get home_screen_filter_category => 'Categoría';

  @override
  String get home_screen_filter_type => 'Tipo';

  @override
  String get home_screen_filter_season => 'Temporada';

  @override
  String get home_screen_filter_reset => 'Restablecer';

  @override
  String get home_screen_filter_apply => 'Aplicar';

  @override
  String get home_screen_error_state => 'Error al cargar los datos';

  @override
  String get home_screen_empty_state => 'No hay zapatos en la caja';

  @override
  String get home_screen_no_results_state =>
      'Ningún zapato coincide con los filtros seleccionados';

  @override
  String get home_screen_no_results_reset => 'Borrar filtros';

  @override
  String get shoes_adder_screen_title => 'Añadir Zapatos';

  @override
  String get shoes_adder_screen_field_color_primary => 'Primario';

  @override
  String get shoes_adder_screen_field_brand => 'Marca';

  @override
  String get shoes_adder_screen_field_size => 'Tamaño';

  @override
  String get shoes_adder_screen_field_category => 'Categoría';

  @override
  String get shoes_adder_screen_field_type => 'Tipo';

  @override
  String get shoes_adder_screen_select_category => 'Selecciona una categoría';

  @override
  String get shoes_adder_screen_select_type => 'Selecciona un tipo';

  @override
  String get shoes_adder_screen_field_season => 'Temporada';

  @override
  String get shoes_adder_screen_field_note => 'Notas';

  @override
  String get shoes_form_screen_section_photo => 'Foto';

  @override
  String get shoes_form_screen_section_colors => 'Colores';

  @override
  String get shoes_form_screen_section_details => 'Detalles';

  @override
  String get shoes_form_screen_section_notes => 'Notas';

  @override
  String get shoes_form_screen_add_photo => 'Añadir foto';

  @override
  String get shoes_adder_screen_crop_image_title => 'Recortar Imagen';

  @override
  String get shoes_adder_screen_toast_error_image =>
      'No seleccionaste una imagen';

  @override
  String get shoes_adder_screen_toast_error_color =>
      'No seleccionaste el color primario';

  @override
  String get shoes_adder_screen_toast_error_brand => 'No ingresaste la marca';

  @override
  String get shoes_adder_screen_toast_error_size => 'No ingresaste el tamaño';

  @override
  String get shoes_adder_screen_toast_error_category =>
      'No seleccionaste una categoría';

  @override
  String get shoes_adder_screen_toast_error_type => 'No seleccionaste un tipo';

  @override
  String get shoes_adder_screen_toast_success => '¡Zapatos añadidos con éxito!';

  @override
  String get shoes_adder_screen_toast_error => 'Error durante el guardado';

  @override
  String get shoes_form_screen_bg_remove_loading => 'Eliminando fondo...';

  @override
  String get shoes_form_screen_bg_remove_success => 'Fondo eliminado con éxito';

  @override
  String get shoes_form_screen_bg_remove_error =>
      'Error al eliminar el fondo: ';

  @override
  String get shoes_updater_screen_title => 'Actualizar Zapatos';

  @override
  String get shoes_updater_screen_field_color_primary => 'Color Primario';

  @override
  String get shoes_updater_screen_field_brand => 'Marca';

  @override
  String get shoes_updater_screen_field_size => 'Tamaño';

  @override
  String get shoes_updater_screen_field_category => 'Categoría';

  @override
  String get shoes_updater_screen_field_type => 'Tipo';

  @override
  String get shoes_updater_screen_field_season => 'Temporada';

  @override
  String get shoes_updater_screen_field_note => 'Notas';

  @override
  String get shoes_updater_screen_crop_image_title => 'Recortar Imagen';

  @override
  String get shoes_updater_screen_toast_error_brand => 'No ingresaste la marca';

  @override
  String get shoes_updater_screen_toast_error_size => 'No ingresaste el tamaño';

  @override
  String get shoes_updater_screen_toast_success =>
      '¡Zapatos actualizados con éxito!';

  @override
  String get shoes_updater_screen_toast_error =>
      'Error durante la actualización';

  @override
  String get shoes_details_screen_title => 'Detalles de los Zapatos';

  @override
  String get shoes_details_screen_field_color => 'COLORES';

  @override
  String get shoes_details_screen_field_color_primary => 'Primario';

  @override
  String get shoes_details_screen_field_brand => 'MARCA';

  @override
  String get shoes_details_screen_field_size => 'TAMAÑO';

  @override
  String get shoes_details_screen_field_category => 'CATEGORÍA';

  @override
  String get shoes_details_screen_field_type => 'TIPO';

  @override
  String get shoes_details_screen_field_season => 'TEMPORADA';

  @override
  String get shoes_details_screen_field_note => 'NOTAS';

  @override
  String get shoes_details_screen_menu_edit => 'Editar';

  @override
  String get shoes_details_screen_menu_share => 'Compartir';

  @override
  String get shoes_details_screen_menu_delete => 'Eliminar';

  @override
  String get shoes_details_screen_share_success =>
      'Captura de pantalla compartida con éxito!';

  @override
  String get shoes_details_screen_share_error =>
      'Error al compartir la captura de pantalla';

  @override
  String get shoes_details_screen_error_state => 'Error al cargar los datos';

  @override
  String get shoes_details_screen_empty_state => 'No se encontraron zapatos';

  @override
  String get shoes_details_screen_delete_title => 'Elimina';

  @override
  String get shoes_details_screen_delete_description =>
      '¿Seguro que quieres eliminar estos zapatos?';

  @override
  String get shoes_details_screen_delete_toast_success =>
      '¡Zapatos eliminados!';

  @override
  String get user_screen_title => 'Perfil';

  @override
  String get user_screen_button_database => 'Base de datos';

  @override
  String get user_screen_button_logout => 'Cerrar sesión';

  @override
  String get user_screen_button_delete => 'Borrar cuenta';

  @override
  String get user_updater_screen_title => 'Editar Perfil';

  @override
  String get user_updater_screen_crop_image_title => 'Recortar Imagen';

  @override
  String get user_updater_screen_save => 'Guardar';

  @override
  String get user_updater_screen_username_field_error =>
      'No ingresaste el nombre';

  @override
  String get database_screen_title => 'Database';

  @override
  String get database_screen_empty => 'No hay zapatos en el box';

  @override
  String get database_screen_colors => 'Colores';

  @override
  String get database_screen_brands => 'Brands';

  @override
  String get database_screen_categories => 'Categorías';

  @override
  String get database_screen_types => 'Tipos';

  @override
  String get database_screen_pdf_download => 'Descargar PDF';

  @override
  String get database_screen_pdf_confirm =>
      'PDF guardado en la carpeta de Descargas';

  @override
  String get database_screen_pdf_error => 'No se pudo generar el PDF';

  @override
  String get database_screen_export_menu => 'Exportar JSON';

  @override
  String get database_screen_import_menu => 'Importar JSON';

  @override
  String get database_screen_export_success =>
      'JSON exportado a la carpeta de descargas';

  @override
  String get database_screen_export_error => 'Error durante la exportación';

  @override
  String get database_screen_import_success => 'JSON importado correctamente!';

  @override
  String get database_screen_import_error => 'Error durante la importación';

  @override
  String get delete_account_screen_title => 'Borrar cuenta';

  @override
  String get delete_account_screen_toast_success => '¡Cuenta eliminada!';

  @override
  String get delete_account_screen_toast_error =>
      'Error durante el proceso de eliminación:';

  @override
  String get delete_account_screen_delete_dialog_title =>
      'Confirmar eliminación';

  @override
  String get delete_account_screen_delete_dialog_text =>
      '¿Estás seguro de que deseas eliminar permanentemente tu cuenta?';

  @override
  String get delete_account_screen_text_a =>
      '¿Estás realmente seguro de que deseas eliminar tu cuenta?';

  @override
  String get delete_account_screen_text_b =>
      'Esta es una acción irreversible y todos los datos asociados a esta cuenta serán eliminados permanentemente sin posibilidad de recuperación.';

  @override
  String get delete_account_screen_text_c =>
      'Para continuar, haz clic en el botón de abajo';

  @override
  String get delete_account_screen_delete_button => 'Eliminar';

  @override
  String get delete_account_screen_backup_title => 'Respalda Tus Datos';

  @override
  String get delete_account_screen_backup_text =>
      'Antes de eliminar tu cuenta, ¿deseas descargar una copia de seguridad de tu base de datos de zapatos en formato JSON? Esto te ayudará a preservar tus datos.';

  @override
  String get delete_account_screen_backup_button =>
      'Descargar Copia de Seguridad';

  @override
  String get delete_account_screen_skip_backup => 'Omitir';

  @override
  String get delete_account_screen_backup_success =>
      '¡Base de datos respaldada exitosamente!';

  @override
  String get delete_account_screen_backup_error =>
      'Error durante la copia de seguridad:';

  @override
  String get delete_account_screen_what_happens => '¿Qué pasará?';

  @override
  String get delete_account_screen_item_a =>
      'Tu perfil y credenciales de inicio de sesión se eliminarán permanentemente';

  @override
  String get delete_account_screen_item_b =>
      'Todos los zapatos guardados en tu base de datos serán eliminados';

  @override
  String get delete_account_screen_item_c =>
      'Las imágenes asociadas a tus zapatos serán borradas';

  @override
  String get settings_screen_language => 'Idioma';

  @override
  String get settings_screen_info => 'Info';

  @override
  String get settings_screen_policy => 'Privacy Policy';

  @override
  String get settings_screen_support => 'Mesa de ayuda';

  @override
  String get info_screen_title => 'Información';

  @override
  String get info_screen_origin_text => 'ORIGEN';

  @override
  String get info_screen_origin_description =>
      'El nombre de la aplicación es una fusión entre \'Shoes\' y \'Box\', para simular la creación de una gran caja donde guardar los zapatos.';

  @override
  String get info_screen_description_text => 'DESCRIPCIÓN';

  @override
  String get info_screen_description_description =>
      'Esta aplicación te permite crear un armario digital personalizado exclusivamente para tus zapatos. Aquí, puedes guardar, organizar y visualizar fácilmente todos tus zapatos en un solo lugar virtual. Cada par de zapatos puede catalogarse con detalles específicos como marca, modelo, color y ocasión de uso, lo que facilita encontrar exactamente lo que buscas en cualquier momento. Con tu armario digital, siempre tendrás una vista completa de tu colección de zapatos al alcance de tu mano, facilitando la elección del par perfecto para cada ocasión.';

  @override
  String get info_screen_credits_text => 'CRÉDITOS';

  @override
  String get info_screen_credits_a_text => 'Idea';

  @override
  String get info_screen_credits_a_value => 'Nicola De Nicolais';

  @override
  String get info_screen_credits_b_text => 'Desarrollo';

  @override
  String get info_screen_credits_b_value => 'Nicola De Nicolais';

  @override
  String get info_screen_credits_c_text => 'Diseño';

  @override
  String get info_screen_credits_c_value => 'Nicola De Nicolais';

  @override
  String get policy_screen_title => 'Política de privacidad';

  @override
  String get support_screen_title => 'Soporte';

  @override
  String get support_screen_contacts_text => 'Contáctanos';

  @override
  String get support_screen_contacts_decription =>
      'Para cualquier problema o pregunta, escribe a:';

  @override
  String get support_screen_contacts_info => 'ndn21dev@gmail.com';

  @override
  String get support_screen_faq_text => 'FAQ';

  @override
  String get support_screen_faq_decription =>
      'Encuentra respuestas a las preguntas más frecuentes.';

  @override
  String get support_screen_faq_q1 => '¿Cómo agregar un par de zapatos?';

  @override
  String get support_screen_faq_a1 =>
      'Para agregar un par de zapatos, ve a la página de inicio y haz clic en el botón \'+\'. Completa todos los detalles necesarios y guarda.';

  @override
  String get support_screen_faq_q2 => '¿Cómo modificar un par de zapatos?';

  @override
  String get support_screen_faq_a2 =>
      'Para modificar un par de zapatos, elige el cuadro de los zapatos que deseas modificar y haz clic en él. Una vez abierto, haz clic en el icono en la parte superior derecha y elige la opción \'Modificar\'. Realiza los cambios y guarda.';

  @override
  String get support_screen_faq_q3 => '¿Cómo eliminar un par de zapatos?';

  @override
  String get support_screen_faq_a3 =>
      'Para eliminar un par de zapatos, elige el cuadro de los zapatos que deseas modificar y haz clic en él. Una vez abierto, haz clic en el icono en la parte superior derecha y elige la opción \'Eliminar\'.';

  @override
  String get support_screen_faq_q4 => '¿Qué pasa si elimino un par de zapatos?';

  @override
  String get support_screen_faq_a4 =>
      'Si eliminas un par de zapatos, se eliminará permanentemente. Se te pedirá que confirmes antes de proceder con la operación.';

  @override
  String get support_screen_faq_q7 =>
      '¿Qué puedo hacer si la aplicación no funciona correctamente?';

  @override
  String get support_screen_faq_a7 =>
      'Si tienes problemas, intenta reiniciar la aplicación. Si el problema persiste, contacta con el soporte técnico a través de la sección \'Contáctanos\'.';

  @override
  String get support_screen_faq_q8 =>
      '¿Qué puedo hacer si la aplicación no funciona?';

  @override
  String get support_screen_faq_a8 =>
      'Cierra la aplicación desde el segundo plano > Configuración de la aplicación > Eliminar datos > Vaciar caché > Reiniciar la aplicación. Si el problema persiste, contacta con el soporte técnico.';

  @override
  String get support_screen_faq_q9 => '¿Cómo funciona la descarga de PDF?';

  @override
  String get support_screen_faq_a9 =>
      'Para descargar tu base de datos en formato PDF ve a la sección Perfil > Base de datos > Haz clic en el icono en la esquina superior derecha > Descargar PDF.';

  @override
  String get support_screen_faq_q10 =>
      '¿Cómo funciona la importación de base de datos JSON?';

  @override
  String get support_screen_faq_a10 =>
      'Puedes importar la base de datos en formato JSON (si se exportó previamente desde la aplicación).';

  @override
  String get support_screen_faq_q11 =>
      '¿Cómo funciona la exportación de base de datos JSON?';

  @override
  String get support_screen_faq_a11 =>
      'Puedes exportar la base de datos en formato JSON para preservar los datos actuales presentes en la base de datos y luego poder importarlos en otro dispositivo a través de la aplicación.';

  @override
  String get support_screen_documentation_text => 'Documentación';

  @override
  String get support_screen_documentation_decription =>
      'Consulta la documentación completa en la página web de la aplicación.';

  @override
  String get support_screen_documentation_info =>
      'Ir a la página web en GitHub';

  @override
  String get color_white => 'Blanco';

  @override
  String get color_black => 'Negro';

  @override
  String get color_light_grey => 'Gris Claro';

  @override
  String get color_dark_grey => 'Gris Oscuro';

  @override
  String get color_orange => 'Naranja';

  @override
  String get color_pink => 'Rosa';

  @override
  String get color_red => 'Rojo';

  @override
  String get color_bordeaux => 'Borgoña';

  @override
  String get color_camel => 'Camel';

  @override
  String get color_beige => 'Beige';

  @override
  String get color_light_brown => 'Marrón Claro';

  @override
  String get color_dark_brown => 'Marrón Oscuro';

  @override
  String get color_yellow => 'Amarillo';

  @override
  String get color_green => 'Verde';

  @override
  String get color_light_blue => 'Azul Claro';

  @override
  String get color_dark_blue => 'Azul Oscuro';

  @override
  String get category_sneakers => 'Zapatillas';

  @override
  String get category_elegant => 'Elegante';

  @override
  String get category_heeled => 'Con tacón';

  @override
  String get category_sandals => 'Sandalias';

  @override
  String get category_mules => 'Mulas';

  @override
  String get category_boots => 'Botas';

  @override
  String get category_other => 'Otro';

  @override
  String get type_sport => 'Deporte';

  @override
  String get type_casual => 'Casual';

  @override
  String get type_lifestyle => 'Estilo de vida';

  @override
  String get type_running => 'Correr';

  @override
  String get type_dressy => 'Elegante';

  @override
  String get type_loafers => 'Mocasines';

  @override
  String get type_decollete => 'Escotado';

  @override
  String get type_spuntas => 'Punta abierta';

  @override
  String get type_wedge => 'Con cuña';

  @override
  String get type_lace_up => 'Cordones';

  @override
  String get type_flat => 'Plano';

  @override
  String get type_heeled => 'Con tacón';

  @override
  String get type_ankle_boots => 'Botines';

  @override
  String get type_high_boots => 'Botas altas';

  @override
  String get type_work_boots => 'Botas de trabajo';

  @override
  String get type_knee_high => 'Hasta la rodilla';

  @override
  String get type_classic => 'Clásico';

  @override
  String get type_other => 'Otro';

  @override
  String get pdf_field_id => 'ID';

  @override
  String get pdf_field_date => 'Fecha';

  @override
  String get pdf_field_color_primary => 'Color Primario';

  @override
  String get pdf_field_color_secondary => 'Color Secundario';

  @override
  String get pdf_field_brand => 'Brand';

  @override
  String get pdf_field_size => 'Talla';

  @override
  String get pdf_field_category => 'Categoría';

  @override
  String get pdf_field_type => 'Tipo';

  @override
  String get pdf_field_season => 'Estación';

  @override
  String get pdf_field_notes => 'Notas';

  @override
  String get pdf_copyright => '© 2024 Nicola De Nicolais';

  @override
  String get full_screen_image_save_success_toast =>
      '¡Imagen guardada con éxito!';

  @override
  String get full_screen_image_save_error_toast => 'Error';

  @override
  String get full_screen_image_download_error_toast =>
      'No se pudo descargar la imagen.';

  @override
  String get full_screen_image_share_success_toast =>
      '¡Imagen compartida con éxito!';

  @override
  String get full_screen_image_share_download_error_toast =>
      'No se pudo descargar la imagen para compartir.';

  @override
  String get full_screen_image_share_error_toast => 'Error';

  @override
  String get custom_delete_dialog_confirm => 'Eliminar';

  @override
  String get custom_delete_dialog_cancel => 'Cancelar';

  @override
  String get database_screen_pdf_user => 'Usuario';

  @override
  String get database_screen_pdf_name => 'Nombre';

  @override
  String get database_screen_pdf_email => 'Correo electrónico';

  @override
  String get database_screen_pdf_date => 'Fecha';

  @override
  String get database_screen_pdf_shoes => 'Zapatos';

  @override
  String get database_screen_pdf_page => 'Página';

  @override
  String get auth_or_continue_with => 'O continuar con';

  @override
  String get auth_sign_in_with_google => 'Iniciar sesión con Google';

  @override
  String get common_retry => 'Reintentar';

  @override
  String get dashboard_screen_title => 'Panel';

  @override
  String get dashboard_preferences => 'Preferencias';

  @override
  String get dashboard_theme => 'Tema';

  @override
  String get theme_mode_system => 'Sistema';

  @override
  String get theme_mode_light => 'Claro';

  @override
  String get theme_mode_dark => 'Oscuro';

  @override
  String get dashboard_account => 'Cuenta';

  @override
  String get dashboard_profile => 'Perfil';

  @override
  String get dashboard_logout => 'Cerrar sesión';

  @override
  String get dashboard_share_app => 'Compartir';

  @override
  String get dashboard_version => 'Versión';

  @override
  String get dashboard_information => 'App';

  @override
  String get dashboard_changelog => 'Changelog';

  @override
  String get a11y_profile => 'Perfil';

  @override
  String get a11y_settings => 'Ajustes';

  @override
  String get a11y_add_shoe => 'Añadir zapato';

  @override
  String get a11y_filters => 'Filtros';

  @override
  String get a11y_clear_search => 'Borrar búsqueda';

  @override
  String get a11y_toggle_grid => 'Cambiar disposición de la cuadrícula';

  @override
  String get a11y_show_only_favorites => 'Mostrar solo favoritos';

  @override
  String get a11y_show_all_shoes => 'Mostrar todos los zapatos';

  @override
  String get a11y_add_to_favorites => 'Añadir a favoritos';

  @override
  String get a11y_remove_from_favorites => 'Quitar de favoritos';

  @override
  String get a11y_open_image => 'Abrir imagen a pantalla completa';

  @override
  String get a11y_download_image => 'Descargar imagen';

  @override
  String get a11y_share_image => 'Compartir imagen';

  @override
  String get a11y_take_photo => 'Hacer una foto';

  @override
  String get a11y_pick_from_gallery => 'Elegir de la galería';

  @override
  String get a11y_remove_image => 'Quitar imagen';

  @override
  String get a11y_remove_background => 'Quitar fondo';

  @override
  String get a11y_save_shoe => 'Guardar zapato';

  @override
  String get a11y_edit_profile => 'Editar perfil';

  @override
  String get a11y_change_profile_photo => 'Cambiar foto de perfil';

  @override
  String get a11y_loading => 'Cargando';

  @override
  String get changelog_dialog_title => 'Novedades';

  @override
  String get changelog_dialog_close => 'Cerrar';

  @override
  String get changelog_v4_1_0_bullet_1 =>
      'Rediseño gráfico de la app con estilo Material 3, manteniendo la paleta de colores original.';

  @override
  String get changelog_v4_1_0_bullet_2 =>
      'Añadido un diseño realmente responsive que se adapta a móviles y tablets, con rotación libre de pantalla.';

  @override
  String get changelog_v4_1_0_bullet_3 =>
      'Nuevo selector de tema Sistema / Claro / Oscuro.';

  @override
  String get changelog_v4_1_0_bullet_4 =>
      'Se movió la eliminación de la cuenta a la pantalla de perfil para un acceso más sencillo.';

  @override
  String get changelog_v4_1_0_bullet_5 =>
      'Rediseñado el selector de idioma para un aspecto más claro y coherente.';

  @override
  String get changelog_v4_1_0_bullet_6 =>
      'Añadido este diálogo de novedades para mantenerte informado después de cada actualización.';

  @override
  String get changelog_v4_1_0_bullet_7 =>
      'Corregida la legibilidad de los textos en modo oscuro en el selector de tema y en las estadísticas del perfil.';

  @override
  String get changelog_v4_1_0_bullet_8 =>
      'Solucionada la superposición de los gráficos en la sección de base de datos.';

  @override
  String get changelog_v4_1_0_bullet_9 =>
      'Ajustado el tamaño de textos, iconos e imágenes en el formulario de añadir/editar zapatilla para una mejor visualización en smartphones.';

  @override
  String get changelog_v4_1_0_bullet_10 =>
      'Reestructurada la sección de información de la app.';

  @override
  String get changelog_v4_1_0_bullet_11 =>
      'Rediseñado el formulario de añadir/editar zapato con un diseño más claro, en tarjetas y secciones.';

  @override
  String get changelog_v4_1_0_bullet_12 =>
      'Renovado el marcador de posición para elegir foto en el formulario de zapatos, acorde al nuevo estilo de tarjetas.';

  @override
  String get changelog_v4_1_0_bullet_13 =>
      'El restablecimiento de filtros ahora borra todos los filtros, incluidos color, categoría y favoritos.';

  @override
  String get changelog_v4_1_0_bullet_14 =>
      'El icono de filtros se resalta solo cuando hay un filtro realmente aplicado.';

  @override
  String get changelog_v4_1_0_bullet_15 =>
      'Corregido el filtro de categoría \"Todas\", que vaciaba la cuadrícula en lugar de mostrar todos los zapatos.';

  @override
  String get changelog_v4_1_0_bullet_16 =>
      'Cuando ningún zapato coincide con los filtros aparece un mensaje dedicado con un botón para borrarlos.';

  @override
  String get changelog_v4_1_0_bullet_17 =>
      'El botón de añadir ya no tapa la última fila de la cuadrícula.';

  @override
  String get changelog_v4_1_0_bullet_18 =>
      'Los botones con solo icono ahora tienen etiquetas y descripciones, legibles por los lectores de pantalla.';

  @override
  String get changelog_v4_1_0_bullet_19 =>
      'Ampliada el área táctil de los botones de perfil y ajustes en la barra superior.';

  @override
  String get changelog_v4_1_0_bullet_20 =>
      'La lista de zapatos ahora se filtra fuera del dibujado de la pantalla: desplazamiento más fluido y sin reordenar los datos subyacentes.';

  @override
  String get changelog_v4_1_0_bullet_21 =>
      'La versión de la app en el panel se carga una sola vez en lugar de en cada redibujado.';

  @override
  String get changelog_v4_1_0_bullet_22 =>
      'El inicio de sesión con Google ahora muestra un mensaje de error, por ejemplo sin conexión, en lugar de no hacer nada.';

  @override
  String get changelog_v4_1_0_bullet_23 =>
      'Si la app no consigue iniciarse, ahora aparece una pantalla con un botón Reintentar en lugar de un cierre repentino.';

  @override
  String get changelog_v4_1_0_bullet_24 =>
      'Si la sesión caduca, la app ahora vuelve a la pantalla de bienvenida en lugar de cerrarse de repente.';

  @override
  String get dashboard_other => 'Otro';

  @override
  String get user_screen_account_settings => 'Configuración de cuenta';

  @override
  String get user_screen_total_shoes => 'Total de zapatos';

  @override
  String get user_screen_member_since => 'Miembro desde';

  @override
  String get user_screen_favorite_brand => 'Marca favorita';

  @override
  String get user_screen_most_used_category => 'Más usado';

  @override
  String get user_screen_most_used_type => 'Tipo Más Usado';

  @override
  String get user_screen_most_used_color => 'Color Más Usado';

  @override
  String get user_screen_last_added => 'Último agregado';

  @override
  String get user_screen_favorites_count => 'Favoritos';

  @override
  String get full_screen_image_share_text => '¡Mira esta imagen!';

  @override
  String get extra_colors => 'Extra';

  @override
  String get select_extra_colors => 'Seleccionar colores extra';

  @override
  String get add_more_colors => 'Agregar más colores';
}
