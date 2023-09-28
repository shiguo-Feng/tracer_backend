def preprocess_date(date_str):
    """Convert a full ISO 8601 date-time string to a YYYY-MM-DD format."""
    if date_str:
        return date_str[:10]
    return None
