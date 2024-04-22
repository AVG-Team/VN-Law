import React, { useState } from "react";
import { lawQuestions } from "~/mock/questions.data";
import { useMediaQuery } from "react-responsive";
import { TrashIcon } from "@heroicons/react/24/solid";
import { isToday, isYesterday, isInLastWeek, isInLastMonth, isInLastYear, convertDateFormat } from "./GetDate";

const truncateText = (text, maxLength) => {
    if (text.length > maxLength) {
        return text.substr(0, maxLength) + "...";
    }
    return text;
};

const maxLength = 25;

const sortedQuestions = lawQuestions.sort((a, b) => parseInt(b.view) - parseInt(a.view));

export const TopQuestions = ({ sendQuestion }) => {
    const isLargeScreen = useMediaQuery({ query: "(min-width: 1024px)" });
    const topQuestions = isLargeScreen ? sortedQuestions.slice(0, 4) : sortedQuestions.slice(0, 2);
    return (
        <div className="grid grid-cols-1 gap-2 mx-8 my-4 lg:grid-cols-2 lg:gap-4 lg:m-8 top-questions">
            {topQuestions.map((question, index) => (
                <button
                    onClick={() => {
                        sendQuestion(question.question);
                    }}
                    key={index}
                    className="border-gray-400 border-[0.25px] rounded-lg hover:bg-slate-300 cursor-pointer"
                >
                    <p className="text-lg text-gray-700">{question.field}</p>
                    <p className="px-1 text-sm text-gray-400">{truncateText(question.question, 80)}</p>
                </button>
            ))}
        </div>
    );
};

// Define the custom hook outside the component
const useQuestionList = (questions) => {
    const [questionList, setQuestionList] = useState(questions);

    const handleDeleteQuestion = (index) => {
        const updatedQuestionList = [...questionList];
        updatedQuestionList.splice(index, 1);
        setQuestionList(updatedQuestionList);
    };

    return { questionList, handleDeleteQuestion };
};

const LawQuestions = () => {
    const { questionList, handleDeleteQuestion } = useQuestionList(lawQuestions);

    const renderQuestionBlocks = (questions, title) => {
        return (
            <div className="mt-3">
                <p className="mb-3 ml-2 text-base text-gray-500">{title}</p>
                {questionList.map((question, index) => (
                    <div
                        key={index}
                        className="flex items-center justify-between p-2 my-1 cursor-pointer hover:rounded-lg hover:bg-slate-300"
                    >
                        <p>{truncateText(question.question, maxLength)}</p>
                        <TrashIcon
                            className="w-4 h-4 text-black opacity-50 cursor-pointer hover:opacity-100"
                            onClick={() => handleDeleteQuestion(index)}
                        />
                    </div>
                ))}
            </div>
        );
    };

    const todayQuestions = lawQuestions.filter((question) => isToday(convertDateFormat(question.date)));
    const yesterdayQuestions = lawQuestions.filter((question) => isYesterday(convertDateFormat(question.date)));
    const previousSevenDaysQuestions = lawQuestions.filter((question) =>
        isInLastWeek(convertDateFormat(question.date)),
    );
    const previousMonthQuestions = lawQuestions.filter((question) => isInLastMonth(convertDateFormat(question.date)));
    const previousYearQuestions = lawQuestions.filter((question) => isInLastYear(convertDateFormat(question.date)));

    return (
        <>
            {renderQuestionBlocks(todayQuestions, "Hôm Nay")}
            {renderQuestionBlocks(yesterdayQuestions, "Ngày Hôm Qua")}
            {renderQuestionBlocks(previousSevenDaysQuestions, "7 Ngày Trước")}
            {renderQuestionBlocks(previousMonthQuestions, "1 Tháng Trước")}
            {renderQuestionBlocks(previousYearQuestions, "1 Năm Trước")}
        </>
    );
};

export default LawQuestions;
