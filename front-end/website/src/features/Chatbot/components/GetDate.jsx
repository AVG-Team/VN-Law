export const isToday = (inputDate) => {
    const today = new Date();
    const input = new Date(inputDate);

    return (
        input.getDate() === today.getDate() &&
        input.getMonth() === today.getMonth() &&
        input.getFullYear() === today.getFullYear()
    );
};

export const isYesterday = (inputDate) => {
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    const input = new Date(inputDate);

    return (
        input.getDate() === yesterday.getDate() &&
        input.getMonth() === yesterday.getMonth() &&
        input.getFullYear() === yesterday.getFullYear()
    );
};

export const isInLastWeek = (inputDate) => {
    const today = new Date();
    const lastWeek = new Date(today.getFullYear(), today.getMonth(), today.getDate() - 7);
    const input = new Date(inputDate);

    return input >= lastWeek && input < today;
};

export const isInLastMonth = (inputDate) => {
    const today = new Date();
    const lastMonth = new Date(today.getFullYear(), today.getMonth() - 1, today.getDate());
    const input = new Date(inputDate);

    return input.getMonth() === lastMonth.getMonth() && input.getFullYear() === lastMonth.getFullYear();
};

export const isInLastYear = (inputDate) => {
    const today = new Date();
    const lastYear = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
    const input = new Date(inputDate);

    return input.getFullYear() === lastYear.getFullYear();
};

export function convertDateFormat(inputDate) {
    const parts = inputDate.split("-");
    const year = parseInt(parts[2]);
    const month = parseInt(parts[1]) - 1;
    const day = parseInt(parts[0]);
    return new Date(year, month, day);
}
