def predict(features):
    return round(sum(features) / max(len(features), 1), 4)
