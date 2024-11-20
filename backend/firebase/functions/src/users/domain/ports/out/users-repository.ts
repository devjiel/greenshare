
export interface UsersRepository {
    removeFileFromUser(userUid: string, fileUid: string): Promise<void>;
}