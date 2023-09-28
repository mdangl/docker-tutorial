export const environment = {
    todoApiUrl: () => (window as {[key: string]: any})["env"]["todoApiUrl"]
}