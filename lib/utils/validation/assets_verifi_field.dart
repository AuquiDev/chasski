 String getField(dynamic field) {
    return (field == null || field.toString().isEmpty)
        ? 'N/A'
        : field.toString();
  }