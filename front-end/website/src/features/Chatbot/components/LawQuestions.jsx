import React, { useState } from "react";
import { lawQuestions } from "~/mock/questions.data";
import { useMediaQuery } from "react-responsive";
import { TrashIcon } from "@heroicons/react/24/solid";
import { deleteConversation } from "~/api/chat-service/chat-service";
import { useNavigate, useLocation } from "react-router-dom";
import {
    isTodayTimestamp,
    isYesterdayTimestamp,
    convertToTimestamp,
    isInLastMonthTimestamp,
    isInLastYearTimestamp,
    isInLastWeekTimestamp,
} from "./GetDate";
import { toast } from "react-toastify";

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

const LawQuestions = ({data}) => {
    const navigate = useNavigate();
    const location = useLocation();
    const [questionList, setQuestionList] = useState(data);

    const handleClickQuestion = (questionId) => {
        const newPath = `/chatbot/${questionId}`;
        if (location.pathname !== newPath) {
            navigate(newPath, { replace: true });
        }
    }

    const deleteQuestionFromServer = async (questionId) => {
        try {
            const response = await deleteConversation(questionId);
            console.log(response);
            toast.success("Xoá thành công", {
                autoClose: 2000,
                buttonClose: false
            });
        } catch (error) {
            console.error(error.message);
        }
    }

    const handleDeleteQuestion = (questionId) => {
        const isConfirmed = window.confirm("Bạn có chắc chắn muốn xóa đoạn chat này không?");
        if (isConfirmed) {
            const updatedData = questionList.filter(question => question.id !== questionId);
            setQuestionList(updatedData);
            deleteQuestionFromServer(questionId).then();
        }
    };

    const renderQuestionBlocks = (questions, title) => {
        return questions.length <= 0 ? null : (
            <div className="mt-3">
                <p className="mb-3 ml-2 text-base text-gray-500">{title}</p>
                {questions.map((question) => (
                    <div
                        key={question.id} data-id={question.id} onClick={() => handleClickQuestion(question.id)}
                        className="flex items-center justify-between p-2 my-1 cursor-pointer hover:rounded-lg hover:bg-slate-300"
                    >
                        <p>{truncateText(question.title, maxLength)}</p>
                        <TrashIcon
                            className="w-4 h-4 text-black opacity-50 cursor-pointer hover:opacity-100"
                            onClick={(e) => {
                                e.stopPropagation();
                                handleDeleteQuestion(question.id)}}
                        />
                    </div>
                ))}
            </div>
        );
    };

    const todayQuestions = questionList.filter((question) => isTodayTimestamp(convertToTimestamp(question.updated_at)));
    const yesterdayQuestions = questionList.filter((question) => isYesterdayTimestamp(convertToTimestamp(question.updated_at)));
    const previousSevenDaysQuestions = questionList.filter((question) =>
        isInLastWeekTimestamp(convertToTimestamp(question.updated_at)),
    );
    const previousMonthQuestions = questionList.filter((question) => isInLastMonthTimestamp(convertToTimestamp(question.updated_at)));
    const previousYearQuestions = questionList.filter((question) => isInLastYearTimestamp(convertToTimestamp(question.updated_at)));

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
