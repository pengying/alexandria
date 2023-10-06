export function populatePromptTemplate(template: string, variables: any): string {
    return template.replace(/\${(.*?)}/g, (_, key) => variables[key.trim()] || '');
}

