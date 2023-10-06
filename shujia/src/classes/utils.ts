export function populatePromptTemplate(template: string, variables: any): string {
    return template.replace(/\${(.*?)}/g, (_, key) => variables[key.trim()] || '');
}

type JSONObject = { [key: string]: any };

export function lowerCaseKeys(obj: JSONObject): JSONObject {
  const result: JSONObject = {};

  for (let key in obj) {
    const lowercaseKey = key.toLowerCase();
    if (typeof obj[key] === 'object' && obj[key] !== null && !Array.isArray(obj[key])) {
      result[lowercaseKey] = lowerCaseKeys(obj[key]);
    } else {
      result[lowercaseKey] = obj[key];
    }
  }

  return result;
}