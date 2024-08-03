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

const DAY_IN_MS = 24 * 60 * 60 * 1000;

export const isTodayTimestamp = (timestamp) => {
    const today = new Date().setHours(0, 0, 0, 0);
    return timestamp >= today && timestamp < today + DAY_IN_MS;
};

export const isYesterdayTimestamp = (timestamp) => {
    const today = new Date().setHours(0, 0, 0, 0);
    const yesterday = today - DAY_IN_MS;
    return timestamp >= yesterday && timestamp < today;
};

export const isInLastWeekTimestamp = (timestamp) => {
    const today = new Date().setHours(0, 0, 0, 0);
    const weekAgo = today - 7 * DAY_IN_MS;
    return timestamp >= weekAgo && timestamp < today - DAY_IN_MS;
};

export const isInLastMonthTimestamp = (timestamp) => {
    const now = new Date();
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate()).getTime();
    const lastMonth = new Date(now.getFullYear(), now.getMonth() - 1, now.getDate()).getTime();
    return timestamp >= lastMonth && timestamp < today - 7 * DAY_IN_MS;
};

export const isInLastYearTimestamp = (timestamp) => {
    const now = new Date();
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate()).getTime();
    const lastYear = new Date(now.getFullYear() - 1, now.getMonth(), now.getDate()).getTime();
    return timestamp >= lastYear && timestamp < today - 30 * DAY_IN_MS;
};

export function convertToTimestamp(inputDate) {
    return new Date(inputDate).getTime();
}
