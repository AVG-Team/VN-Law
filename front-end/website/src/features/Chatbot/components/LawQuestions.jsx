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
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-2 lg:gap-4 lg:m-8 mx-8 my-4 top-questions">
            {topQuestions.map((question, index) => (
                <div
                    onClick={() => {
                        sendQuestion(question.question);
                    }}
                    key={index}
                    className="border-gray-400 border-[0.25px] rounded-lg hover:bg-slate-300 cursor-pointer"
                >
                    <p className="text-lg text-gray-700">{question.field}</p>
                    <p className="text-sm text-gray-400 px-1">{truncateText(question.question, 80)}</p>
                </div>
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
                <p className="text-base mb-3 text-gray-500 ml-2">{title}</p>
                {questionList.map((question, index) => (
                    <div
                        key={index}
                        className="flex justify-between items-center my-1 p-2 hover:rounded-lg hover:bg-slate-300 cursor-pointer"
                    >
                        <p>{truncateText(question.question, maxLength)}</p>
                        <TrashIcon
                            className="w-4 h-4 text-black opacity-50 hover:opacity-100 cursor-pointer"
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
